"""Install, update, and remove packages."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from .builder import build_port, package_filename
from .deps import ResolvedInstallPlan, packages_for_install, resolve_packages_for_install
from .port import Port, load_port
from .registry import InstalledPackage, is_installed, load_installed, remove_record, save_installed
from .util import (
    libtool_finish_installed_files,
    remove_files,
    run_cmd,
    run_install_extract,
    run_with_processing_indicator,
)


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


def _run_post_rebuilds(
    paths: dict[str, Path],
    parent: str,
    post_deps: list[str],
) -> list[str]:
    """Rebuild packages listed in *parent*'s post dependencies."""
    rebuilt: list[str] = []
    for dep in post_deps:
        if dep == parent:
            continue
        print(f"=== post rebuild {dep} (after {parent}) ===")
        _install_one(paths, dep, force=True, rebuilding=True)
        rebuilt.append(dep)
    return rebuilt


def _collect_post_rebuilds(
    ports_dir: Path,
    order: list[str],
) -> list[tuple[str, str]]:
    """Return (parent, post_dep) pairs for packages in *order*."""
    pairs: list[tuple[str, str]] = []
    for name in order:
        try:
            port = load_port(ports_dir, name)
        except FileNotFoundError:
            continue
        for dep in port.dependencies.post:
            if dep != name:
                pairs.append((name, dep))
    return pairs


def force_install_command(names: list[str]) -> str:
    quoted = " ".join(names)
    return f"alps install --force {quoted}"


def _cycle_warning_lines(cycles: list[list[str]], names: list[str]) -> list[str]:
    lines = [
        "WARNING: circular dependency detected "
        "(packages in the cycle may fail to install):",
    ]
    for cycle in cycles:
        lines.append(f"  {' -> '.join(cycle)}")
    lines.append("")
    lines.append(
        "To install only the requested package(s) without dependencies "
        "(not recorded by ALPS):"
    )
    lines.append(f"  {force_install_command(names)}")
    return lines


def _print_cycle_warnings(cycles: list[list[str]], names: list[str]) -> None:
    for line in _cycle_warning_lines(cycles, names):
        print(line)


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
    libtool_finish_installed_files(files, as_root=True)
    for cmd in port.post_install:
        run_cmd(cmd, as_root=True)
    print(f"force installed {name}: {len(files)} files (not recorded by ALPS)")


def _install_one(
    paths: dict[str, Path],
    name: str,
    *,
    force: bool,
    requested: bool = False,
    rebuilding: bool = False,
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
    label = "rebuilding" if rebuilding else "installing"
    print(f"=== {label} {name} {port.version} ===")
    user_requested = requested or keep_requested
    if port.meta:
        record = InstalledPackage.now(name, port.version, [], "", requested=user_requested)
        save_installed(paths["installed"], record)
        dep_count = len(port.dependencies.required) + len(port.dependencies.pre)
        print(
            f"installed {name}: metapackage "
            f"({dep_count} declared dependencies, no files to install)"
        )
        return
    package_path, files = build_port(
        port,
        sources_dir=paths["sources"],
        staging_dir=paths["staging"],
        packages_dir=paths["packages"],
    )
    run_install_extract(port.install.extract, package_path=package_path)
    libtool_finish_installed_files(files, as_root=True)
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
) -> tuple[ResolvedInstallPlan, list[tuple[str, str]]]:
    installed = _installed_set(paths["installed"])
    resolved = resolve_packages_for_install(
        paths["ports"],
        names,
        installed=installed,
    )
    post_rebuilds = _collect_post_rebuilds(paths["ports"], resolved.order)
    return resolved, post_rebuilds


def preview_install_plan(
    config: dict[str, str],
    names: list[str],
    *,
    user_targets: set[str] | None = None,
) -> tuple[list[str], list[tuple[str, str]]]:
    """Return packages to install and planned post rebuilds, in build order."""
    del user_targets
    paths = _paths(config)
    resolved, post_rebuilds = _resolve_install(paths, names)
    return resolved.order, post_rebuilds


def format_install_plan(
    config: dict[str, str],
    names: list[str],
    *,
    user_targets: set[str] | None = None,
) -> InstallPlanReport:
    """Human-readable install plan for confirmation prompts."""
    paths = _paths(config)

    def _build_report() -> InstallPlanReport:
        resolved, post_rebuilds = _resolve_install(paths, names)
        lines: list[str] = []
        order = resolved.order

        if resolved.cycles:
            lines.extend(_cycle_warning_lines(resolved.cycles, names))
            lines.append("")

        if not order and not post_rebuilds:
            if resolved.cycles:
                return InstallPlanReport(text="\n".join(lines).rstrip(), can_proceed=False)
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

        if post_rebuilds:
            lines.append("")
            lines.append(
                "These packages will be rebuilt after their parent installs:"
            )
            for parent, dep in post_rebuilds:
                port = load_port(paths["ports"], dep)
                version = port.version or "?"
                lines.append(f"  - {dep} {version}  (post after {parent})")

        total = len(order)
        if post_rebuilds:
            lines.append("")
            lines.append(
                f"Total: {total} package(s) to install, "
                f"{len(post_rebuilds)} post rebuild(s)"
            )
        else:
            lines.append("")
            lines.append(f"Total: {total} package(s)")
        return InstallPlanReport(text="\n".join(lines), can_proceed=True)

    return run_with_processing_indicator(_build_report)


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
    force: bool = False,
    user_targets: set[str] | None = None,
) -> None:
    paths = _paths(config)
    for p in paths.values():
        p.mkdir(parents=True, exist_ok=True)

    installed = _installed_set(paths["installed"])
    resolved = resolve_packages_for_install(
        paths["ports"], names, installed=installed,
    )
    if resolved.cycles:
        _print_cycle_warnings(resolved.cycles, names)
    order = resolved.order

    explicit_targets = user_targets or set()
    session_installed: list[str] = []
    for name in order:
        already = is_installed(paths["installed"], name)
        _install_one(paths, name, force=force, requested=name in explicit_targets)
        if not already or force:
            session_installed.append(name)
        port = load_port(paths["ports"], name)
        if port.dependencies.post:
            for rebuilt in _run_post_rebuilds(paths, name, port.dependencies.post):
                if rebuilt not in session_installed:
                    session_installed.append(rebuilt)


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
