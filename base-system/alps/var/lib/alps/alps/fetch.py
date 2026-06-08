"""Fetch port definitions from the local repository or a remote source."""

from __future__ import annotations

import shutil
from pathlib import Path


def fetch_ports(dest: Path, source: Path) -> int:
    """Copy port JSON files from *source* into *dest*."""
    if not source.is_dir():
        raise FileNotFoundError(f"Ports source not found: {source}")
    dest.mkdir(parents=True, exist_ok=True)
    count = 0
    for path in sorted(source.glob("*.json")):
        shutil.copy2(path, dest / path.name)
        count += 1
    return count


def default_repo_ports() -> Path:
    """Ports bundled with the AryaLinux checkout (build host)."""
    return Path("/var/cache/alps/ports")
