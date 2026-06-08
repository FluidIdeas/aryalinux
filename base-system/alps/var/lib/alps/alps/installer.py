"""Install, update, and remove packages."""

from __future__ import annotations

from pathlib import Path

from .builder import build_port, package_filename
from .deps import packages_for_install
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
    order = packages_for_install(
        paths["ports"], names, installed=installed, include_recommended=include_recommended,
    )

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
