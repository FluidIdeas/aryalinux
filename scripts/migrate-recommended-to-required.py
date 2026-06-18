#!/usr/bin/env python3
"""Merge dependencies.recommended into dependencies.required in port JSON files.

BLFS recommended dependencies are treated as required in AryaLinux. Circular
recommended pairs (handled via post-rebuild in BLFS) are routed elsewhere:

  libva + mesa       -> runtime on libva (mesa post-rebuilds libva)
  gdk-pixbuf + glycin -> optional on gdk-pixbuf (glycin post-rebuilds gdk-pixbuf)
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

# (port, dependency) -> alternate dependency list key
CIRCULAR_EXCEPTIONS: dict[tuple[str, str], str] = {
    ("libva", "mesa"): "runtime",
    ("gdk-pixbuf", "glycin"): "optional",
}


def migrate_port(data: dict) -> bool:
    deps = data.get("dependencies")
    if not isinstance(deps, dict):
        return False
    recommended = deps.get("recommended")
    if not recommended:
        return False

    name = data.get("name", "")
    required = list(deps.get("required", []))
    changed = False

    for dep in recommended:
        target_key = CIRCULAR_EXCEPTIONS.get((name, dep), "required")
        if target_key == "required":
            if dep not in required:
                required.append(dep)
                changed = True
        else:
            bucket = list(deps.get(target_key, []))
            if dep not in bucket:
                bucket.append(dep)
                deps[target_key] = bucket
                changed = True

    if required != deps.get("required", []):
        deps["required"] = required
        changed = True

    del deps["recommended"]
    if not deps.get("required"):
        deps.pop("required", None)

    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--ports-dir",
        type=Path,
        default=Path(__file__).resolve().parents[1] / "applications",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    updated: list[str] = []
    for path in sorted(args.ports_dir.glob("*.json")):
        if path.name in {"categories.json", "port-audit.json"}:
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        if not migrate_port(data):
            continue
        updated.append(path.stem)
        if not args.dry_run:
            path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    for name in updated:
        print(name)
    print(f"{'would update' if args.dry_run else 'updated'} {len(updated)} port(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
