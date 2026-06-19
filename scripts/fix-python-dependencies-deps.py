#!/usr/bin/env python3
"""Replace python-dependencies metapackage deps with concrete python-deps.* ports.

python-dependencies is meta: true and does not install build backends. Ports
that use pip --no-build-isolation must depend on the specific python-deps.*
packages named in BLFS.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PORTS = ROOT / "applications"
BLFS = ROOT / "parser/blfs-book-13.0-systemd-html"

ANCHOR_ALIASES = {
    "sphinx_rtd_theme": "sphinx_rtd_theme",
}

DEP_ANCHOR_ALIASES = {
    "pyproject-hooks": "python-deps.pyproject-hooks",
    "pyproject-metadata": "python-deps.pyproject-metadata",
    "meson_python": "python-deps.meson_python",
    "setuptools_scm": "python-deps.setuptools_scm",
    "setuptools_rust": "python-deps.setuptools_rust",
    "uv_build": "python-deps.uv_build",
    "charset-normalizer": "python-deps.charset-normalizer",
    "roman-numerals": "python-deps.roman-numerals",
    "hatch-fancy-pypi-readme": "python-deps.hatch-fancy-pypi-readme",
    "hatch-vcs": "python-deps.hatch-vcs",
    "sc-applehelp": "python-deps.sc-applehelp",
    "sc-devhelp": "python-deps.sc-devhelp",
    "sc-htmlhelp": "python-deps.sc-htmlhelp",
    "sc-jsmath": "python-deps.sc-jsmath",
    "sc-jquery": "python-deps.sc-jquery",
    "sc-qthelp": "python-deps.sc-qthelp",
    "sc-serializinghtml": "python-deps.sc-serializinghtml",
}

DEP_LINK_RE = re.compile(
    r"python-dependencies\.html#([a-zA-Z0-9_.-]+)",
    re.IGNORECASE,
)


def port_names() -> set[str]:
    return {p.stem for p in PORTS.glob("*.json")}


def map_anchor(anchor: str, names: set[str]) -> str | None:
    if anchor in DEP_ANCHOR_ALIASES:
        return DEP_ANCHOR_ALIASES[anchor]
    for cand in (f"python-deps.{anchor}", f"python-deps.{anchor.replace('-', '_')}"):
        if cand in names:
            return cand
    return None


def collapse(text: str) -> str:
    return re.sub(r"\s+", " ", text)


def extract_py_deps(html: str, anchor: str, names: set[str]) -> list[str]:
    match = re.search(rf'<a\s+id="{re.escape(anchor)}"', html, re.IGNORECASE)
    if not match:
        return []

    section = html[match.start() :]
    next_anchor = re.search(r'<a\s+id="[^"]+"', section[30:])
    if next_anchor:
        section = section[: 30 + next_anchor.start()]
    install = re.search(
        r"Installation of |<div class=\"installation\"",
        section,
        re.IGNORECASE,
    )
    if install:
        section = section[: install.start()]

    found: list[str] = []
    for class_name in ("required", "recommended"):
        for paragraph in re.finditer(
            rf'<p class="{class_name}">(.*?)</p>',
            section,
            re.IGNORECASE | re.DOTALL,
        ):
            text = collapse(paragraph.group(1))
            for dep_anchor in DEP_LINK_RE.findall(text):
                port = map_anchor(dep_anchor, names)
                if port and port not in found:
                    found.append(port)
    return found


def blfs_anchor(port_name: str) -> str:
    if port_name.startswith("python-modules."):
        anchor = port_name.split(".", 1)[1]
    else:
        anchor = port_name
    return ANCHOR_ALIASES.get(anchor, anchor)


def fix_port(path: Path, names: set[str], dry_run: bool) -> str | None:
    data = json.loads(path.read_text(encoding="utf-8"))
    deps = data.get("dependencies", {})
    required = list(deps.get("required", []))
    if "python-dependencies" not in required:
        return None

    book = data.get("book", "")
    html_path = BLFS / book
    if not html_path.is_file():
        return f"{data['name']}: missing BLFS book {book}"

    html = html_path.read_text(encoding="utf-8", errors="replace")
    py_deps = extract_py_deps(html, blfs_anchor(data["name"]), names)
    other = [dep for dep in required if dep != "python-dependencies"]
    merged: list[str] = []
    for dep in other + py_deps:
        if dep not in merged:
            merged.append(dep)

    if merged == required:
        return f"{data['name']}: no change ({merged})"

    deps["required"] = merged
    data["dependencies"] = deps
    if not dry_run:
        path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return f"{data['name']}: {required} -> {merged}"


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    names = port_names()
    changed = 0
    for path in sorted(PORTS.glob("*.json")):
        if path.name in {"categories.json", "port-audit.json", "python-dependencies.json"}:
            continue
        result = fix_port(path, names, args.dry_run)
        if result:
            print(result)
            if "->" in result:
                changed += 1
    print(f"{'would update' if args.dry_run else 'updated'} {changed} port(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
