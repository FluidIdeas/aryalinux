#!/usr/bin/env python3
"""Download LFS base-system source tarballs listed in wget-list."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
SOURCES = Path.home() / "sources"
WGET_LIST = SCRIPT_DIR / "wget-list"


def main() -> None:
    if not WGET_LIST.is_file():
        sys.exit(f"wget-list not found: {WGET_LIST}")

    SOURCES.mkdir(parents=True, exist_ok=True)
    subprocess.run(["cp", str(WGET_LIST), str(SOURCES / "wget-list")], check=True)

    result = subprocess.run(
        ["wget", "-nc", "-i", "wget-list"],
        cwd=SOURCES,
    )
    if result.returncode != 0:
        sys.exit(result.returncode)

    print(f"Sources downloaded under {SOURCES}")


if __name__ == "__main__":
    main()
