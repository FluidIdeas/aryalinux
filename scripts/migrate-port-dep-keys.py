#!/usr/bin/env python3
"""Normalize port dependency keys for runtime vs post semantics."""

from __future__ import annotations

import json
from pathlib import Path

SKIP = {"categories.json", "port-audit.json"}

# post entries that are runtime-only, not rebuild-after dependencies.
POST_TO_RUNTIME: dict[str, list[str]] = {
    "libsecret": ["gnome-keyring"],
    "gtk3": ["adwaita-icon-theme"],
    "gtk4": ["adwaita-icon-theme"],
}

# post entries that were misclassified and should be removed.
POST_TO_REMOVE: dict[str, list[str]] = {
    "gegl": ["graphviz"],
}


def merge_unique(existing: list[str], extra: list[str]) -> list[str]:
    seen = set(existing)
    merged = list(existing)
    for item in extra:
        if item not in seen:
            merged.append(item)
            seen.add(item)
    return merged


def migrate_deps(name: str, deps: dict) -> dict:
    if not deps:
        return deps

    post = list(deps.get("post", []))
    runtime = list(deps.get("runtime", []))
    rebuild_after = list(deps.get("rebuild_after", []))

    if rebuild_after:
        post = merge_unique(post, rebuild_after)
        deps.pop("rebuild_after", None)

    for dep in POST_TO_RUNTIME.get(name, []):
        if dep in post:
            post.remove(dep)
            runtime = merge_unique(runtime, [dep])

    for dep in POST_TO_REMOVE.get(name, []):
        if dep in post:
            post.remove(dep)

    deps.pop("post", None)
    deps.pop("runtime", None)
    if post:
        deps["post"] = post
    if runtime:
        deps["runtime"] = runtime
    return deps


def main() -> int:
    ports_dir = Path(__file__).resolve().parents[1] / "applications"
    changed = 0
    for path in sorted(ports_dir.glob("*.json")):
        if path.name in SKIP:
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        name = data.get("name", path.stem)
        old_deps = data.get("dependencies", {})
        new_deps = migrate_deps(name, dict(old_deps))
        if new_deps != old_deps:
            if new_deps:
                data["dependencies"] = new_deps
            elif "dependencies" in data:
                del data["dependencies"]
            path.write_text(
                json.dumps(data, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
            changed += 1
    print(f"migrated {changed} port(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
