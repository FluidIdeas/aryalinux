#!/usr/bin/env python3
"""Convert package-map.yaml to package-map.json (stdlib only, no PyYAML)."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
YAML = ROOT / "package-map.yaml"
JSON = ROOT / "package-map.json"

INLINE = re.compile(
    r"^\s*-\s*\{script:\s*([^,]+),\s*tarball:\s*([^,]+),\s*html:\s*([^}]+)\}\s*$"
)


def unquote(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] == '"':
        return bytes(value[1:-1], "utf-8").decode("unicode_escape")
    return value


def parse_inline(line: str) -> dict | None:
    m = INLINE.match(line)
    if not m:
        return None
    return {
        "script": m.group(1).strip(),
        "tarball": m.group(2).strip(),
        "html": m.group(3).strip(),
    }


def parse_yaml(path: Path) -> dict:
    lines = path.read_text(encoding="utf-8").splitlines()
    data: dict = {}
    section: str | None = None
    packages: list | None = None
    current: dict | None = None
    mode: str | None = None  # post_process | replace
    post_item: dict | None = None

    for line in lines:
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        inline = parse_inline(line)
        if inline and packages is not None:
            packages.append(inline)
            current = None
            mode = None
            continue

        if re.match(r"^[a-z_]+:\s*$", line):
            section = line[:-1]
            if section == "cross_toolchain":
                data[section] = []
                packages = data[section]
            else:
                data[section] = {"chapter": "", "packages": []}
                packages = data[section]["packages"]
            current = None
            mode = None
            continue

        if section in ("temp_tools", "additional_temp_tools", "final_system"):
            if line.startswith("  chapter:"):
                data[section]["chapter"] = line.split(":", 1)[1].strip()
                continue
            if line.strip() == "packages:":
                continue

        # New package: "  - script:" (cross) or "    - script:" (chapter packages)
        m = re.match(r"^(\s*)-\s+script:\s+(\S+)\s*$", line)
        if m and packages is not None:
            current = {"script": m.group(2)}
            packages.append(current)
            mode = None
            post_item = None
            continue

        if current is None or not line.startswith(" "):
            continue

        indent = len(line) - len(line.lstrip())
        content = line.strip()

        if mode == "post_process":
            if content.startswith("- search:"):
                post_item = {"search": unquote(content.split(":", 1)[1]), "replace": ""}
                current.setdefault("post_process", []).append(post_item)
                continue
            if content.startswith("replace:") and post_item is not None:
                post_item["replace"] = unquote(content.split(":", 1)[1])
                post_item = None
                continue

        if mode == "replace":
            key, _, val = content.partition(":")
            current.setdefault("replace", {})[key.strip()] = val.strip()
            continue

        key, _, rest = content.partition(":")
        rest = rest.strip()

        if key == "post_process":
            current["post_process"] = []
            mode = "post_process"
            post_item = None
            continue

        if key == "replace" and not rest:
            current["replace"] = {}
            mode = "replace"
            continue

        mode = None
        current[key] = unquote(rest)

    return data


def main() -> None:
    data = parse_yaml(YAML)
    JSON.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    n_pkg = (
        len(data.get("cross_toolchain", []))
        + len(data.get("temp_tools", {}).get("packages", []))
        + len(data.get("additional_temp_tools", {}).get("packages", []))
        + len(data.get("final_system", {}).get("packages", []))
    )
    print(f"Wrote {JSON} ({n_pkg} packages)")


if __name__ == "__main__":
    main()
