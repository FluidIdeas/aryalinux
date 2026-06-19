#!/usr/bin/env python3
"""Find ports that reference supplementary files without listing download URLs.

ALPS only downloads the first ``url`` entry as the main archive. Patches,
extra tarballs, and other BLFS supplementary files must appear in
``additionalUrls`` (or ``patches`` / ``urls``).
"""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PORTS = ROOT / "applications"
BLFS_WGET = ROOT / "parser/blfs-book-13.0-systemd-html/wget-list"
SKIP_FILES = {"categories.json", "port-audit.json", "python-dependencies.json"}
SKIP_BASENAMES = {"xserver21.patch"}  # shipped inside tigervnc tarball

REF_PATTERNS = [
    re.compile(r"(?:\.\./)+([^\s'\";]+)"),
    re.compile(r"patch -Np\d+ -i\s+(?:\.\./)*([^\s]+)"),
    re.compile(r"unzip(?:\s+-o)?\s+(?:\.\./)*([^\s]+\.zip)"),
    re.compile(r"tar -x[fj]?\s+(?:\.\./)+([^\s]+\.tar\.[a-z0-9]+)"),
    re.compile(r"ln -sv\s+(?:\.\./)+([^\s]+)"),
]

SUPP_SUFFIXES = (
    ".patch",
    ".patch.gz",
    ".zip",
    ".tar.gz",
    ".tar.xz",
    ".tar.bz2",
    ".tgz",
    ".pcf.gz",
)


def load_wget_index() -> dict[str, list[str]]:
    index: dict[str, list[str]] = defaultdict(list)
    if BLFS_WGET.is_file():
        for line in BLFS_WGET.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line.startswith("http"):
                index[line.rsplit("/", 1)[-1]].append(line)
    return index


def build_commands(data: dict) -> list[str]:
    cmds: list[str] = []
    build = data.get("build", {})
    for key in ("pre", "user", "package", "root"):
        cmds.extend(build.get(key, []))
    for module in build.get("modules", []):
        for key in ("pre", "user", "package", "root"):
            cmds.extend(module.get(key, []))
    return cmds


def listed_basenames(data: dict) -> set[str]:
    names: set[str] = set()
    for key in ("url", "additionalUrls", "patches", "urls"):
        value = data.get(key, [])
        if isinstance(value, str):
            value = [value]
        for url in value:
            names.add(url.rsplit("/", 1)[-1])
    return names


def referenced_files(data: dict) -> set[str]:
    refs: set[str] = set()
    for cmd in build_commands(data):
        for pattern in REF_PATTERNS:
            for match in pattern.findall(cmd):
                base = match.rsplit("/", 1)[-1]
                if base.startswith("$") or base in SKIP_BASENAMES:
                    continue
                if base.endswith(SUPP_SUFFIXES):
                    refs.add(base)
    return refs


def extra_url_entries(data: dict) -> list[str]:
    """Secondary ``url`` entries that ALPS will not download."""
    urls = data.get("url", [])
    if isinstance(urls, str):
        urls = [urls]
    if len(urls) <= 1:
        return []
    primary = urls[0].rsplit("/", 1)[-1]
    return [u for u in urls[1:] if u.rsplit("/", 1)[-1] != primary]


def audit() -> list[dict]:
    wget = load_wget_index()
    findings: list[dict] = []
    for path in sorted(PORTS.glob("*.json")):
        if path.name in SKIP_FILES:
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        avail = listed_basenames(data)
        missing = sorted(
            ref for ref in referenced_files(data) if ref not in avail
        )
        move_to_additional = []
        for url in extra_url_entries(data):
            base = url.rsplit("/", 1)[-1]
            text = "\n".join(build_commands(data))
            if base in text:
                additional = data.get("additionalUrls", [])
                if not any(
                    u.rsplit("/", 1)[-1] == base for u in additional
                ):
                    move_to_additional.append(url)
        if missing or move_to_additional:
            findings.append(
                {
                    "name": data.get("name", path.stem),
                    "path": path,
                    "missing": missing,
                    "missing_urls": [
                        (m, (wget.get(m) or [None])[0]) for m in missing
                    ],
                    "move_to_additional": move_to_additional,
                }
            )
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="emit JSON")
    args = parser.parse_args()
    findings = audit()
    if args.json:
        print(
            json.dumps(
                [
                    {
                        "name": f["name"],
                        "missing": f["missing"],
                        "missing_urls": f["missing_urls"],
                        "move_to_additional": f["move_to_additional"],
                    }
                    for f in findings
                ],
                indent=2,
            )
        )
        return 0 if not findings else 1
    if not findings:
        print("OK: no supplementary download issues found")
        return 0
    for item in findings:
        print(f"{item['name']}:")
        for base, url in item["missing_urls"]:
            print(f"  missing ref: {base}")
            if url:
                print(f"    suggested: {url}")
        for url in item["move_to_additional"]:
            print(f"  move url[] -> additionalUrls: {url}")
        print()
    print(f"{len(findings)} port(s) need attention")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
