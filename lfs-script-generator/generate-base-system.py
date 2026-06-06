#!/usr/bin/env python3
"""
Generate AryaLinux base-system build scripts from an LFS HTML book.

Usage:
  ./generate-base-system.py
  ./generate-base-system.py --lfs-book ../13.0 --output ../base-system
  ./generate-base-system.py --only cross-toolchain temp-tools
  ./generate-base-system.py --dry-run

Package mapping: edit package-map.yaml (preferred) or package-map.json.
If PyYAML is unavailable, package-map.json is used automatically.

Requires: Python 3.9+
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from pathlib import Path

from lfs_parser import commands_from_page

ROOT = Path(__file__).resolve().parent
DEFAULT_LFS = ROOT.parent / "13.0"
DEFAULT_OUTPUT = ROOT.parent / "base-system"
DEFAULT_MAP = ROOT / "package-map.yaml"
DEFAULT_MAP_JSON = ROOT / "package-map.json"

CHROOT_HEADER = """#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
\texport MAKEFLAGS="-j `nproc`"
fi

NAME={name}

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

"""

CROSS_HEADER = CHROOT_HEADER  # cross-toolchain also starts in /sources

FOOTER = """
fi

cleanup $DIRECTORY
log $NAME
"""


def load_map(path: Path) -> dict:
    if path.suffix == ".json":
        return json.loads(path.read_text(encoding="utf-8"))

    try:
        import yaml
    except ImportError:
        yaml = None

    if yaml is not None and path.exists():
        with path.open(encoding="utf-8") as f:
            return yaml.safe_load(f)

    json_path = path.with_suffix(".json")
    if json_path.exists():
        return json.loads(json_path.read_text(encoding="utf-8"))

    sys.exit(
        f"No package map found. Install python3-yaml and keep {path.name}, "
        f"or provide {json_path.name}"
    )


def tarball_block(tarball: str) -> str:
    return "\n".join([
        f"TARBALL={tarball}",
        "DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)",
        "",
        "tar xf $TARBALL",
        "cd $DIRECTORY",
        "",
    ])


def apply_post_process(body: str, pkg: dict) -> str:
    for item in pkg.get("post_process") or []:
        body = body.replace(item["search"], item["replace"])
    for old, new in (pkg.get("replace") or {}).items():
        body = body.replace(old, new)
    return body


def build_body(book: Path, chapter: str, html_page: str, pkg: dict) -> str:
    ch, page = html_page.split("/", 1) if "/" in html_page else (chapter, html_page)
    cmds = commands_from_page(book, ch, page)
    parts = []
    if pre := pkg.get("pre_body"):
        parts.append(pre.rstrip("\n"))
    parts.append("\n\n".join(cmds))
    body = "\n\n".join(p for p in parts if p) + "\n"
    return apply_post_process(body, pkg)


def wrap_script(name: str, tarball: str, body: str, cross: bool = False) -> str:
    header = CROSS_HEADER if cross else CHROOT_HEADER
    return header.format(name=name) + tarball_block(tarball) + body + FOOTER


def write_script(path: Path, content: str, dry_run: bool) -> None:
    if dry_run:
        print(f"would write {path} ({len(content.splitlines())} lines)")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    path.chmod(0o755)


def gen_cross_toolchain(book: Path, out: Path, data: list, dry_run: bool) -> None:
    for pkg in data:
        script = pkg["script"]
        ch, page = pkg["html"].split("/", 1)
        body = build_body(book, ch, page, pkg)
        content = wrap_script(script, pkg["tarball"], body, cross=True)
        write_script(out / "cross-toolchain" / f"{script}.sh", content, dry_run)


def gen_chapter_packages(
    book: Path,
    out: Path,
    out_subdir: str,
    section: dict,
    dry_run: bool,
    wipe: bool = False,
) -> None:
    chapter = section["chapter"]
    target = out / out_subdir
    if wipe and target.exists() and not dry_run:
        shutil.rmtree(target)
    if not dry_run:
        target.mkdir(parents=True, exist_ok=True)

    for pkg in section["packages"]:
        script = pkg["script"]
        body = build_body(book, chapter, pkg["html"], pkg)
        content = wrap_script(script, pkg["tarball"], body, cross=False)
        write_script(target / f"{script}.sh", content, dry_run)


def copy_wget_list(book: Path, out: Path, dry_run: bool) -> None:
    src = book / "wget-list"
    dst = out / "wget-list"
    if dry_run:
        print(f"would copy {src} -> {dst}")
        return
    shutil.copy(src, dst)


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--lfs-book", type=Path, default=DEFAULT_LFS,
                   help=f"LFS HTML book directory (default: {DEFAULT_LFS})")
    p.add_argument("--output", type=Path, default=DEFAULT_OUTPUT,
                   help=f"base-system output directory (default: {DEFAULT_OUTPUT})")
    p.add_argument("--map", type=Path, default=DEFAULT_MAP,
                   help=f"package mapping YAML (default: {DEFAULT_MAP})")
    p.add_argument(
        "--only",
        nargs="+",
        choices=["wget-list", "cross-toolchain", "temp-tools",
                 "additional-temp-tools", "final-system"],
        help="generate only selected sections (default: all)",
    )
    p.add_argument("--dry-run", action="store_true",
                   help="print actions without writing files")
    return p.parse_args()


def main() -> None:
    args = parse_args()
    book = args.lfs_book.resolve()
    out = args.output.resolve()
    pmap = load_map(args.map)

    if not book.is_dir():
        sys.exit(f"LFS book not found: {book}")

    sections = args.only or [
        "wget-list", "cross-toolchain", "temp-tools",
        "additional-temp-tools", "final-system",
    ]

    if "wget-list" in sections:
        copy_wget_list(book, out, args.dry_run)

    if "cross-toolchain" in sections:
        gen_cross_toolchain(book, out, pmap["cross_toolchain"], args.dry_run)

    if "temp-tools" in sections:
        gen_chapter_packages(book, out, "temp-tools", pmap["temp_tools"],
                             args.dry_run, wipe=False)

    if "additional-temp-tools" in sections:
        gen_chapter_packages(book, out, "additional-temp-tools",
                             pmap["additional_temp_tools"], args.dry_run, wipe=False)

    if "final-system" in sections:
        gen_chapter_packages(book, out, "final-system", pmap["final_system"],
                             args.dry_run, wipe=True)

    if not args.dry_run:
        print(f"Generated scripts under {out}")
    else:
        print("Dry run complete.")


if __name__ == "__main__":
    main()
