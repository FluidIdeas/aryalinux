#!/usr/bin/env python3
"""Verify ports with buildProfile \"full\" match applications/build-profiles/full.json."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PORTS = ROOT / "applications"
PROFILE = PORTS / "build-profiles" / "full.json"


def load_profile() -> dict:
    return json.loads(PROFILE.read_text())


def port_build_text(port: dict) -> str:
    build = port.get("build", {})
    chunks = []
    for key in ("pre", "user", "package"):
        chunks.extend(build.get(key, []))
    for module in build.get("modules", []):
        for key in ("pre", "user", "package"):
            chunks.extend(module.get(key, []))
    return "\n".join(chunks)


def audit_port(name: str, spec: dict, port: dict) -> list[str]:
    issues: list[str] = []
    deps = port.get("dependencies", {})
    required = set(deps.get("required", []))
    post = set(deps.get("post", []))
    text = port_build_text(port)

    for marker in spec.get("requiredMarkers", []):
        if marker not in text:
            issues.append(f"missing build marker: {marker!r}")

    for dep in spec.get("requiredDeps", []):
        if dep not in required:
            issues.append(f"missing required dep: {dep}")

    for dep in spec.get("postRebuilds", []):
        if dep not in post:
            issues.append(f"missing post rebuild: {dep}")

    return issues


def main() -> int:
    profile = load_profile()
    packages = profile.get("packages", {})
    errors: list[str] = []
    checked = 0

    for path in sorted(PORTS.glob("*.json")):
        if path.parent.name == "build-profiles":
            continue
        port = json.loads(path.read_text())
        name = port.get("name", path.stem)
        if port.get("buildProfile") != "full":
            continue
        checked += 1
        spec = packages.get(name)
        if spec is None:
            errors.append(f"{name}: buildProfile=full but no entry in build-profiles/full.json")
            continue
        for issue in audit_port(name, spec, port):
            errors.append(f"{name}: {issue}")

    for name in packages:
        port_path = PORTS / f"{name}.json"
        if not port_path.exists():
            continue
        port = json.loads(port_path.read_text())
        if port.get("buildProfile") != "full":
            errors.append(f"{name}: documented in full profile but port lacks buildProfile=full")

    if errors:
        print("build profile audit FAILED:", file=sys.stderr)
        for err in errors:
            print(f"  - {err}", file=sys.stderr)
        return 1

    print(f"build profile audit OK ({checked} full-profile ports)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
