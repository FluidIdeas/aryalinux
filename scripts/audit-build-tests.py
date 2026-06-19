#!/usr/bin/env python3
"""Find ports that run BLFS test/verification steps during the ALPS build."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PORTS = ROOT / "applications"
SKIP = {"categories.json", "port-audit.json", "xserver-test.json"}

PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    ("make check", re.compile(r"\bmake\s+check\b")),
    ("make test", re.compile(r"\bmake\s+test\b")),
    ("ninja test", re.compile(r"\bninja\s+test\b")),
    ("meson test", re.compile(r"\bmeson\s+test\b")),
    ("ctest", re.compile(r"\bctest\b")),
    ("jtreg", re.compile(r"\bjtreg\b")),
    ("/tmp/test-", re.compile(r"/tmp/test[-_]")),
    ("check-jstest", re.compile(r"check-jstest")),
    ("check-jit", re.compile(r"check-jit")),
    ("pytest run", re.compile(r"\bpytest\s+")),
    ("prove", re.compile(r"\bprove\s+-")),
]


def build_commands(data: dict) -> list[tuple[str, str]]:
    out: list[tuple[str, str]] = []
    build = data.get("build", {})
    for phase in ("pre", "user", "package", "root"):
        for cmd in build.get(phase, []):
            out.append((phase, cmd))
    return out


def audit() -> list[dict]:
    findings: list[dict] = []
    for path in sorted(PORTS.glob("*.json")):
        if path.name in SKIP:
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        hits: list[dict] = []
        for phase, cmd in build_commands(data):
            for label, pattern in PATTERNS:
                if not pattern.search(cmd):
                    continue
                if label == "ctest" and ("cargo-{" in cmd or "cargo-ctest" in cmd):
                    continue
                hits.append({"phase": phase, "label": label, "cmd": cmd})
        if hits:
            findings.append({"name": data.get("name", path.stem), "hits": hits})
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    findings = audit()
    if args.json:
        print(json.dumps(findings, indent=2))
        return 0 if not findings else 1
    if not findings:
        print("OK: no build-time test commands found")
        return 0
    for item in findings:
        print(item["name"] + ":")
        for hit in item["hits"]:
            snippet = hit["cmd"].replace("\n", " ")[:100]
            print(f"  build.{hit['phase']} [{hit['label']}]: {snippet}")
        print()
    print(f"{len(findings)} port(s) run tests during build")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
