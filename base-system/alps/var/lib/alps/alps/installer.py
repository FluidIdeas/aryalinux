"""Install, update, and remove packages."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from .builder import build_port, package_filename
from .deps import ResolvedInstallPlan, packages_for_install, resolve_packages_for_install
from .port import Port, load_port
from .registry import InstalledPackage, is_installed, load_installed, remove_record, save_installed
from .util import remove_files, run_cmd, run_install_extract


class InstallError(Exception):
    pass


def _paths(config: dict[str, str]) -> dict[str, Path]:
    return {
        "ports": Path(config["PORTS_DIR"]),
        "sources": Path(config["SOURCES_DIR"]),
        "packages": Path(config["PACKAGES_DIR"]),
        "staging": Path(config["STAGING_DIR"]),
        "installed": Path(config["INSTALLED_DIR"]),
    }


def _installed_set(installed_dir: Path) -> set[str]:
    if not installed_dir.is_dir():
        return set()
    return {p.stem for p in installed_dir.glob("*.json")}


def _rebuild_candidates(
    ports_dir: Path,
    *,
    order: list[str],
    available: set[str],
) -> list[str]:
    """Ports that should be rebuilt now that bootstrap partners are available."""
    candidates: list[str] = []
    seen: set[str] = set()
    for name in order:
        if name in seen:
            continue
        seen.add(name)
        try:
            port = load_port(ports_dir, name)
        except FileNotFoundError:
            continue
        triggers = port.dependencies.rebuild_after
        if triggers and all(trigger in available for trigger in triggers):
            candidates.append(name)
    return candidates


def force_install_command(names: list[str]) -> str:
    quoted = " ".join(names)
    return f"alps install --force {quoted}"


def _install_one_standalone(paths: dict[str, Path], name: str) -> None:
    """Build and install a single port without dependencies or ALPS tracking."""
    port = load_port(paths["ports"], name)
    if port.meta:
        print(f"skip {name}: metapackages have no files to install in force mode")
        return
    print(f"=== force install {name} {port.version} (not tracked) ===")
    package_path, files = build_port(
        port,
        sources_dir=paths["sources"],
        staging_dir=paths["staging"],
        packages_dir=paths["packages"],
    )
    run_install_extract(port.install.extract, package_path=package_path)
    for cmd in port.post_install:
        run_cmd(cmd, as_root=True)
    print(f"force installed {name}: {len(files)} files (not recorded by ALPS)")


def _install_one(
    paths: dict[str, Path],
    name: str,
    *,
    force: bool,
    requested: bool = False,
) -> None:
    keep_requested = False
    if is_installed(paths["installed"], name):
        old = load_installed(paths["installed"], name)
        keep_requested = old.requested
        if not force:
            print(f"skip {name}: already installed")
            return
        if old.files:
            remove_files(old.files)
        remove_record(paths["installed"], name)
    port = load_port(paths["ports"], name)
    label = "rebuilding" if force and port.dependencies.rebuild_after else "installing"
    print(f"=== {label} {name} {port.version} ===")
    user_requested = requested or keep_requested
    if port.meta:
        record = InstalledPackage.now(name, port.version, [], "", requested=user_requested)
        save_installed(paths["installed"], record)
        return
    package_path, files = build_port(
        port,
        sources_dir=paths["sources"],
        staging_dir=paths["staging"],
        packages_dir=paths["packages"],
    )
    run_install_extract(port.install.extract, package_path=package_path)
    for cmd in port.post_install:
        run_cmd(cmd, as_root=True)
    record = InstalledPackage.now(
        name, port.version, files, str(package_path), requested=user_requested,
    )
    save_installed(paths["installed"], record)
    print(f"installed {name}: {len(files)} files")


@dataclass
class InstallPlanReport:
    text: str
    can_proceed: bool


def _resolve_install(
    paths: dict[str, Path],
    names: list[str],
    *,
    include_recommended: bool,
) -> tuple[ResolvedInstallPlan, list[str]]:
    installed = _installed_set(paths["installed"])
    resolved = resolve_packages_for_install(
        paths["ports"],
        names,
        installed=installed,
        include_recommended=include_recommended,
    )
    rebuild = _rebuild_candidates(
        paths["ports"],
        order=resolved.order,
        available=installed | set(resolved.order),
    )
    return resolved, rebuild


def preview_install_plan(
    config: dict[str, str],
    names: list[str],
    *,
    include_recommended: bool = False,
    user_targets: set[str] | None = None,
) -> tuple[list[str], list[str]]:
    """Return packages to install and any bootstrap rebuilds, in build order."""
    del user_targets
    paths = _paths(config)
    resolved, rebuild = _resolve_install(
        paths, names, include_recommended=include_recommended,
    )
    return resolved.order, rebuild


def format_install_plan(
    config: dict[str, str],
    names: list[str],
    *,
    include_recommended: bool = False,
    user_targets: set[str] | None = None,
) -> InstallPlanReport:
    """Human-readable install plan for confirmation prompts."""
    paths = _paths(config)
    resolved, rebuild = _resolve_install(
        paths, names, include_recommended=include_recommended,
    )
    lines: list[str] = []

    if resolved.cycles:
        lines.append("WARNING: circular dependency detected — install cannot proceed:")
        for cycle in resolved.cycles:
            lines.append(f"  {' -> '.join(cycle)}")
        lines.append("")
        lines.append(
            "To install only the requested package(s) without dependencies "
            "(not recorded by ALPS):"
        )
        lines.append(f"  {force_install_command(names)}")
        return InstallPlanReport(text="\n".join(lines), can_proceed=False)

    order = resolved.order
    if not order and not rebuild:
        return InstallPlanReport(
            text="All requested packages are already installed.",
            can_proceed=False,
        )

    explicit = user_targets or set(names)
    lines.append("The following packages will be installed (in build order):")
    lines.append("")
    for index, name in enumerate(order, 1):
        port = load_port(paths["ports"], name)
        role = "target" if name in explicit else "dependency"
        version = port.version or "?"
        suffix = " (metapackage)" if port.meta else ""
        lines.append(f"  {index:3d}. {name} {version}  [{role}]{suffix}")

    if resolved.deduplicated:
        lines.append("")
        lines.append(
            "Duplicate entries removed from the dependency chain "
            "(shared by multiple targets or paths):"
        )
        for name in resolved.deduplicated:
            lines.append(f"  - {name}")

    if rebuild:
        lines.append("")
        lines.append(
            "These installed packages will be rebuilt once dependencies are in place:"
        )
        for name in rebuild:
            port = load_port(paths["ports"], name)
            triggers = ", ".join(port.dependencies.rebuild_after)
            version = port.version or "?"
            lines.append(f"  - {name} {version}  (rebuild_after: {triggers})")

    total = len(order)
    if rebuild:
        lines.append("")
        lines.append(
            f"Total: {total} package(s) to install, {len(rebuild)} rebuild(s)"
        )
    else:
        lines.append("")
        lines.append(f"Total: {total} package(s)")
    return InstallPlanReport(text="\n".join(lines), can_proceed=True)


def format_force_install_plan(
    config: dict[str, str],
    names: list[str],
) -> str:
    """Human-readable summary for force (standalone) installs."""
    paths = _paths(config)
    lines = [
        "Force install — dependencies ignored, not recorded by ALPS:",
        "",
    ]
    for index, name in enumerate(names, 1):
        port = load_port(paths["ports"], name)
        version = port.version or "?"
        suffix = " (metapackage, skipped)" if port.meta else ""
        lines.append(f"  {index:3d}. {name} {version}{suffix}")
    lines.append("")
    lines.append(f"Total: {len(names)} package(s)")
    return "\n".join(lines)


def force_install_packages(config: dict[str, str], names: list[str]) -> None:
    """Install named packages only; ignore dependencies and ALPS installed records."""
    paths = _paths(config)
    for path in paths.values():
        path.mkdir(parents=True, exist_ok=True)
    for name in names:
        _install_one_standalone(paths, name)


def install_packages(
    config: dict[str, str],
    names: list[str],
    *,
    include_recommended: bool = False,
    force: bool = False,
    user_targets: set[str] | None = None,
) -> None:
    paths = _paths(config)
    for p in paths.values():
        p.mkdir(parents=True, exist_ok=True)

    installed = _installed_set(paths["installed"])
    resolved = resolve_packages_for_install(
        paths["ports"], names, installed=installed, include_recommended=include_recommended,
    )
    if resolved.cycles:
        cycle = resolved.cycles[0]
        raise InstallError(
            "circular dependency detected: " + " -> ".join(cycle)
        )
    order = resolved.order

    explicit_targets = user_targets or set()
    session_installed: list[str] = []
    for name in order:
        already = is_installed(paths["installed"], name)
        _install_one(paths, name, force=force, requested=name in explicit_targets)
        if not already or force:
            session_installed.append(name)

    available = installed | set(session_installed)
    for name in _rebuild_candidates(paths["ports"], order=order, available=available):
        print(f"=== bootstrap rebuild {name} (after {', '.join(load_port(paths['ports'], name).dependencies.rebuild_after)}) ===")
        _install_one(paths, name, force=True)
        if name not in session_installed:
            session_installed.append(name)


def remove_package(config: dict[str, str], name: str) -> None:
    paths = _paths(config)
    if not is_installed(paths["installed"], name):
        raise InstallError(f"{name} is not installed")
    record = load_installed(paths["installed"], name)
    if record.files:
        remove_files(record.files)
    remove_record(paths["installed"], name)
    print(f"removed {name}")


def packages_needing_update(config: dict[str, str]) -> list[str]:
    paths = _paths(config)
    outdated: list[str] = []
    for record in _installed_records(paths):
        try:
            port = load_port(paths["ports"], record.name)
        except FileNotFoundError:
            continue
        if port.version and record.version != port.version:
            outdated.append(record.name)
    return outdated


def _installed_records(paths: dict[str, Path]):
    from .registry import list_installed

    return list_installed(paths["installed"])
