"""Dependency resolution for package installation.

Required and pre dependencies participate in the install dependency chain.
Optional, runtime, and post dependencies are ignored when computing build order.
"""

from __future__ import annotations

from dataclasses import dataclass, field

from .port import Port, load_port


@dataclass
class InstallPlan:
    """Ordered packages to install for a target port."""

    build_order: list[str] = field(default_factory=list)
    pre: list[str] = field(default_factory=list)


@dataclass
class ResolvedInstallPlan:
    """Flattened install order with dependency analysis notes."""

    order: list[str] = field(default_factory=list)
    deduplicated: list[str] = field(default_factory=list)
    cycles: list[list[str]] = field(default_factory=list)


class DependencyError(Exception):
    pass


def _install_chain_deps(port: Port) -> list[str]:
    """Dependencies used when computing install order."""
    return list(port.dependencies.required)


def _port_dependency_names(port: Port) -> list[str]:
    names: list[str] = []
    for name in port.dependencies.pre + _install_chain_deps(port):
        if name not in names:
            names.append(name)
    return names


def _normalize_cycle(cycle: list[str]) -> tuple[str, ...]:
    if len(cycle) < 2:
        return tuple(cycle)
    if cycle[0] == cycle[-1]:
        body = cycle[:-1]
    else:
        body = cycle
    if not body:
        return tuple(cycle)
    rotations = [tuple(body[index:] + body[:index]) for index in range(len(body))]
    return min(rotations)


def find_dependency_cycles(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
) -> list[list[str]]:
    """Return circular dependency chains reachable from *targets*."""
    found: dict[tuple[str, ...], list[str]] = {}
    path: list[str] = []
    on_path: set[str] = set()
    finished: set[str] = set()

    def visit(name: str) -> None:
        if name in installed or name in finished:
            return
        if name in on_path:
            start = path.index(name)
            cycle = path[start:] + [name]
            key = _normalize_cycle(cycle)
            if key not in found:
                found[key] = cycle
            return
        try:
            port = load_port(ports_dir, name)
        except FileNotFoundError:
            finished.add(name)
            return
        path.append(name)
        on_path.add(name)
        for dep in _port_dependency_names(port):
            visit(dep)
        path.pop()
        on_path.remove(name)
        finished.add(name)

    for target in targets:
        visit(target)
    return list(found.values())


def _collect_dependency_graph(
    ports_dir,
    names: list[str],
    *,
    already: set[str],
) -> dict[str, set[str]]:
    """Collect direct dependencies for *names* and their transitive deps."""
    graph: dict[str, set[str]] = {}
    finished: set[str] = set()

    def collect(name: str, stack: set[str]) -> None:
        if name in already or name in finished:
            return
        if name in stack:
            return
        try:
            port = load_port(ports_dir, name)
        except FileNotFoundError:
            finished.add(name)
            return
        if name not in graph:
            deps = {
                dep for dep in _port_dependency_names(port)
                if dep not in already
            }
            graph[name] = deps
        stack.add(name)
        for dep in graph[name]:
            collect(dep, stack)
        stack.remove(name)
        finished.add(name)

    for name in names:
        collect(name, set())
    return graph


def _topological_sort(
    graph: dict[str, set[str]],
    preference: list[str] | None = None,
) -> list[str]:
    """Return *graph* keys so every dependency appears before its dependents.

    When multiple nodes are ready, prefer the order in *preference* (e.g. a
    metapackage's declared dependency list) over alphabetical sorting.
    """
    if not graph:
        return []

    pref_rank = {name: index for index, name in enumerate(preference or [])}

    def rank(node: str) -> tuple[int, str]:
        return (pref_rank.get(node, len(pref_rank)), node)

    in_degree = {
        node: len([dep for dep in graph[node] if dep in graph])
        for node in graph
    }
    ready = sorted(
        (node for node, degree in in_degree.items() if degree == 0),
        key=rank,
    )
    order: list[str] = []

    while ready:
        node = ready.pop(0)
        order.append(node)
        for other, deps in graph.items():
            if node not in deps:
                continue
            in_degree[other] -= 1
            if in_degree[other] == 0:
                ready.append(other)
                ready.sort(key=rank)

    if len(order) < len(graph):
        for node in sorted(graph):
            if node not in order:
                order.append(node)
    return order


def resolve_install_plan(
    ports_dir,
    target: str,
    *,
    installed: set[str],
    satisfied: set[str] | None = None,
) -> InstallPlan:
    """Return packages that must be built/installed before *target*."""
    already = installed | (satisfied or set())
    try:
        target_port = load_port(ports_dir, target)
    except FileNotFoundError:
        return InstallPlan()

    pre_all: list[str] = []
    for pre in target_port.dependencies.pre:
        if pre not in already and pre not in pre_all:
            pre_all.append(pre)

    dep_names = _port_dependency_names(target_port)
    graph = _collect_dependency_graph(
        ports_dir,
        dep_names + pre_all,
        already=already,
    )
    order = _topological_sort(graph, preference=dep_names + pre_all)
    return InstallPlan(build_order=order, pre=pre_all)


def resolve_packages_for_install(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
) -> ResolvedInstallPlan:
    """Flattened install order for multiple targets with analysis notes."""
    cycles = find_dependency_cycles(
        ports_dir,
        targets,
        installed=installed,
    )

    result: list[str] = []
    seen: set[str] = set()
    deduplicated: list[str] = []

    def add(name: str) -> None:
        if name in installed:
            return
        if name in seen:
            if name not in deduplicated:
                deduplicated.append(name)
            return
        seen.add(name)
        result.append(name)

    for target in targets:
        plan = resolve_install_plan(
            ports_dir,
            target,
            installed=installed,
            satisfied=seen,
        )
        for name in plan.build_order + plan.pre:
            add(name)
        add(target)
    return ResolvedInstallPlan(order=result, deduplicated=deduplicated, cycles=cycles)


def packages_for_install(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
) -> list[str]:
    """Flattened install order for multiple targets."""
    return resolve_packages_for_install(
        ports_dir,
        targets,
        installed=installed,
    ).order
