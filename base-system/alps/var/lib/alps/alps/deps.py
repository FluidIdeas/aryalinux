"""Dependency resolution with pre/post variant support."""

from __future__ import annotations

from dataclasses import dataclass, field

from .port import Port, load_port


@dataclass
class InstallPlan:
    """Ordered packages to install for a target port."""

    build_order: list[str] = field(default_factory=list)
    pre: list[str] = field(default_factory=list)
    post: list[str] = field(default_factory=list)


@dataclass
class ResolvedInstallPlan:
    """Flattened install order with dependency analysis notes."""

    order: list[str] = field(default_factory=list)
    deduplicated: list[str] = field(default_factory=list)
    cycles: list[list[str]] = field(default_factory=list)


class DependencyError(Exception):
    pass


def _all_deps(port: Port, include_recommended: bool) -> list[str]:
    deps = list(port.dependencies.required)
    if include_recommended:
        deps.extend(port.dependencies.recommended)
    return deps


def _port_dependency_names(port: Port, include_recommended: bool) -> list[str]:
    names: list[str] = []
    for name in port.dependencies.pre + _all_deps(port, include_recommended) + port.dependencies.post:
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
    include_recommended: bool = False,
) -> list[list[str]]:
    """Return circular dependency chains reachable from *targets*."""
    found: dict[tuple[str, ...], list[str]] = {}
    path: list[str] = []
    on_path: set[str] = set()

    def visit(name: str) -> None:
        if name in installed:
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
            return
        path.append(name)
        on_path.add(name)
        for dep in _port_dependency_names(port, include_recommended):
            visit(dep)
        path.pop()
        on_path.remove(name)

    for target in targets:
        visit(target)
    return list(found.values())


def resolve_install_plan(
    ports_dir,
    target: str,
    *,
    installed: set[str],
    include_recommended: bool = False,
    satisfied: set[str] | None = None,
) -> InstallPlan:
    """Return packages that must be built/installed before *target*."""
    visiting: set[str] = set()
    order: list[str] = []
    pre_all: list[str] = []
    post_all: list[str] = []
    already = installed | (satisfied or set())

    def visit(name: str) -> None:
        if name in already or name in order:
            return
        if name in visiting:
            raise DependencyError(f"circular dependency involving {name}")
        visiting.add(name)
        port = load_port(ports_dir, name)
        for pre in port.dependencies.pre:
            if pre not in already:
                visit(pre)
                if pre not in pre_all:
                    pre_all.append(pre)
        for dep in _all_deps(port, include_recommended):
            if dep not in already:
                visit(dep)
                if dep not in order:
                    order.append(dep)
        visiting.remove(name)

    visit(target)
    target_port = load_port(ports_dir, target)
    for pre in target_port.dependencies.pre:
        if pre not in already and pre not in pre_all:
            pre_all.append(pre)
    for post in target_port.dependencies.post:
        if post not in already:
            post_all.append(post)

    return InstallPlan(build_order=order, pre=pre_all, post=post_all)


def resolve_packages_for_install(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
    include_recommended: bool = False,
) -> ResolvedInstallPlan:
    """Flattened install order for multiple targets with analysis notes."""
    cycles = find_dependency_cycles(
        ports_dir,
        targets,
        installed=installed,
        include_recommended=include_recommended,
    )
    if cycles:
        return ResolvedInstallPlan(order=[], deduplicated=[], cycles=cycles)

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
            include_recommended=include_recommended,
            satisfied=seen,
        )
        for name in plan.build_order + plan.pre:
            add(name)
        add(target)
        for post_name in plan.post:
            post_plan = resolve_install_plan(
                ports_dir,
                post_name,
                installed=installed,
                include_recommended=include_recommended,
                satisfied=seen,
            )
            for name in post_plan.build_order + post_plan.pre:
                add(name)
            add(post_name)
    return ResolvedInstallPlan(order=result, deduplicated=deduplicated, cycles=[])


def packages_for_install(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
    include_recommended: bool = False,
) -> list[str]:
    """Flattened install order for multiple targets."""
    return resolve_packages_for_install(
        ports_dir,
        targets,
        installed=installed,
        include_recommended=include_recommended,
    ).order
