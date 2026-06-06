#!/usr/bin/env python3
"""Download BLFS/extras sources and bundle local ALPS packages."""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
PARENT_ROOT = REPO_ROOT.parent
SOURCES = Path.home() / "sources"
WGET_LIST = SCRIPT_DIR / "additional-wget-list"
DEFAULTS_FILE = SCRIPT_DIR / "build-defaults.json"
LOCAL_PATCHES = SCRIPT_DIR / "patches"
EXTERNAL_PATCHES = PARENT_ROOT / "patches"

PATCH_NAMES = (
    "efivar-39-upstream_fixes-1.patch",
    "unzip-6.0-consolidated_fixes-1.patch",
)


def load_defaults() -> dict:
    with DEFAULTS_FILE.open(encoding="utf-8") as f:
        return json.load(f)


def read_urls(path: Path) -> list[str]:
    urls = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            urls.append(line)
    return urls


def wget(url: str, *, cwd: Path) -> None:
    result = subprocess.run(["wget", "-nc", url], cwd=cwd)
    if result.returncode != 0:
        sys.exit(result.returncode)


def copy_patches(target: Path) -> None:
    target.mkdir(parents=True, exist_ok=True)
    defaults = load_defaults()
    lfs_book = defaults["lfs_book_version"]
    blfs_patch_base = (
        f"https://www.linuxfromscratch.org/patches/blfs/{lfs_book}"
    )

    for name in PATCH_NAMES:
        dest = target / name
        if dest.exists():
            continue
        for src_dir in (LOCAL_PATCHES, EXTERNAL_PATCHES):
            src = src_dir / name
            if src.is_file():
                shutil.copy2(src, dest)
                print(f"copied {src} -> {dest}")
                break
        else:
            if name == "efivar-39-upstream_fixes-1.patch":
                wget(f"{blfs_patch_base}/{name}", cwd=target)


def bundle_alps(defaults: dict) -> None:
    os_version = defaults["os"]["version"]
    alps_dir = SCRIPT_DIR / "alps"
    apps_dir = REPO_ROOT / "applications"

    if alps_dir.is_dir():
        archive = SOURCES / f"alps-new-{os_version}.tar.gz"
        with tarfile.open(archive, "w:gz") as tar:
            for path in sorted(alps_dir.rglob("*")):
                tar.add(path, arcname=path.relative_to(alps_dir))
        print(f"created {archive}")
    else:
        print(f"warning: {alps_dir} not found; skipping alps tarball", file=sys.stderr)

    if apps_dir.is_dir():
        scripts = sorted(apps_dir.glob("*.sh"))
        if not scripts:
            print(f"warning: no *.sh in {apps_dir}", file=sys.stderr)
            return
        archive = SOURCES / f"alps-scripts-{os_version}.tar.gz"
        with tarfile.open(archive, "w:gz") as tar:
            for script in scripts:
                tar.add(script, arcname=script.name)
        print(f"created {archive}")
    else:
        print(f"warning: {apps_dir} not found", file=sys.stderr)


def main() -> None:
    if not WGET_LIST.is_file():
        sys.exit(f"additional-wget-list not found: {WGET_LIST}")
    if not DEFAULTS_FILE.is_file():
        sys.exit(f"build-defaults.json not found: {DEFAULTS_FILE}")

    defaults = load_defaults()
    SOURCES.mkdir(parents=True, exist_ok=True)

    for url in read_urls(WGET_LIST):
        wget(url, cwd=SOURCES)

    patches_dest = SOURCES / "patches"
    copy_patches(patches_dest)
    bundle_alps(defaults)

    print(f"Additional downloads complete under {SOURCES}")


if __name__ == "__main__":
    main()
