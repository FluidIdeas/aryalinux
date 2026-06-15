"""Find installed packages that are no longer needed."""

from __future__ import annotations

from pathlib import Path

from .port import Port, load_port
from .registry import InstalledPackage, list_installed


def _install_chain_deps(port: Port) -> set[str]:
    deps = port.dependencies
    return set(deps.required) | set(deps.pre)


def find_orphans(ports_dir: Path, installed_dir: Path) -> list[str]:
    """Packages installed only as dependencies with no remaining dependents."""
    records = list_installed(installed_dir)
    if not records:
        return []

    installed_names = {record.name for record in records}
    depended_on: set[str] = set()
    for record in records:
        try:
            port = load_port(ports_dir, record.name)
        except FileNotFoundError:
            continue
        depended_on |= _install_chain_deps(port) & installed_names

    orphans: list[str] = []
    for record in records:
        if record.requested:
            continue
        if record.name not in depended_on:
            orphans.append(record.name)
    return sorted(orphans)


def print_orphan_notice(config: dict[str, str]) -> None:
    """Print installed dependency-only packages that nothing else requires."""
    paths = {
        "ports": Path(config["PORTS_DIR"]),
        "installed": Path(config["INSTALLED_DIR"]),
    }
    orphans = find_orphans(paths["ports"], paths["installed"])
    if not orphans:
        return

    print(
        "The following packages were installed only as dependencies and are no longer needed: "
        + ", ".join(orphans)
    )
    print("Use 'alps orphans' to list them or 'alps remove <pkg>' to uninstall.")
    print("")
