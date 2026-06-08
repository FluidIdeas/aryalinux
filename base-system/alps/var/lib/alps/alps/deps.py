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


class DependencyError(Exception):
    pass


def _all_deps(port: Port, include_recommended: bool) -> list[str]:
    deps = list(port.dependencies.required)
    if include_recommended:
        deps.extend(port.dependencies.recommended)
    return deps


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


def packages_for_install(
    ports_dir,
    targets: list[str],
    *,
    installed: set[str],
    include_recommended: bool = False,
) -> list[str]:
    """Flattened install order for multiple targets."""
    result: list[str] = []
    seen: set[str] = set()

    def add(name: str) -> None:
        if name in seen or name in installed:
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
    return result
