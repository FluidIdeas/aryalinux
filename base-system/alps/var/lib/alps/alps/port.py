"""ALPS port definitions (JSON)."""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


@dataclass
class PortDependencies:
    required: list[str] = field(default_factory=list)
    recommended: list[str] = field(default_factory=list)
    optional: list[str] = field(default_factory=list)
    pre: list[str] = field(default_factory=list)
    runtime: list[str] = field(default_factory=list)
    post: list[str] = field(default_factory=list)


@dataclass
class PortBuildModule:
    name: str
    version: str
    url: str
    pre: list[str] = field(default_factory=list)
    user: list[str] = field(default_factory=list)
    package: list[str] = field(default_factory=list)
    root: list[str] = field(default_factory=list)


@dataclass
class PortBuild:
    pre: list[str] = field(default_factory=list)
    user: list[str] = field(default_factory=list)
    package: list[str] = field(default_factory=list)
    root: list[str] = field(default_factory=list)
    environment: dict[str, str] = field(default_factory=dict)
    modules: list[PortBuildModule] = field(default_factory=list)


@dataclass
class PortInstall:
    extract: list[str] = field(default_factory=lambda: ["tar -xJf $PACKAGE -C /"])


def _url_list(value: Any) -> list[str]:
    if isinstance(value, str):
        return [value] if value else []
    if isinstance(value, list):
        return [u for u in value if isinstance(u, str) and u]
    return []


def _dedupe(urls: list[str]) -> list[str]:
    seen: set[str] = set()
    out: list[str] = []
    for url in urls:
        if url not in seen:
            seen.add(url)
            out.append(url)
    return out


def _merge_dep_lists(*lists: list[str]) -> list[str]:
    merged: list[str] = []
    seen: set[str] = set()
    for items in lists:
        for item in items:
            if item not in seen:
                seen.add(item)
                merged.append(item)
    return merged


@dataclass
class Port:
    name: str
    version: str = ""
    description: str = ""
    category: str = ""
    source_urls: list[str] = field(default_factory=list)
    additional_urls: list[str] = field(default_factory=list)
    dependencies: PortDependencies = field(default_factory=PortDependencies)
    build: PortBuild = field(default_factory=PortBuild)
    install: PortInstall = field(default_factory=PortInstall)
    post_install: list[str] = field(default_factory=list)
    meta: bool = False
    book: str = ""
    build_profile: str = ""


def _parse_port(data: dict[str, Any]) -> Port:
    deps_raw = data.get("dependencies", {})
    build_raw = data.get("build", {})
    install_raw = data.get("install", {})
    modules = [PortBuildModule(**m) for m in build_raw.get("modules", [])]
    source_urls = _dedupe(_url_list(data.get("url", "")))
    additional_urls = _dedupe(
        _url_list(data.get("additionalUrls", []))
        + data.get("patches", [])
        + data.get("urls", [])
    )
    return Port(
        name=data["name"],
        version=data.get("version", ""),
        description=data.get("description", ""),
        category=data.get("category", data.get("section", "")),
        source_urls=source_urls,
        additional_urls=additional_urls,
        dependencies=PortDependencies(
            required=deps_raw.get("required", []),
            recommended=deps_raw.get("recommended", []),
            optional=deps_raw.get("optional", []),
            pre=deps_raw.get("pre", []),
            runtime=deps_raw.get("runtime", []),
            post=_merge_dep_lists(
                deps_raw.get("post", []),
                deps_raw.get("rebuild_after", []),
            ),
        ),
        build=PortBuild(
            pre=build_raw.get("pre", []),
            user=build_raw.get("user", []),
            package=build_raw.get("package", []),
            root=build_raw.get("root", []),
            environment=build_raw.get("environment", {}),
            modules=modules,
        ),
        install=PortInstall(
            extract=install_raw.get("extract", ["tar -xJf $PACKAGE -C /"]),
        ),
        post_install=data.get("post_install", []),
        meta=data.get("meta", False),
        book=data.get("book", ""),
        build_profile=data.get("buildProfile", ""),
    )


def port_path(ports_dir: Path, name: str) -> Path:
    return ports_dir / f"{name}.json"


def load_port(ports_dir: Path, name: str) -> Port:
    path = port_path(ports_dir, name)
    if not path.is_file():
        raise FileNotFoundError(f"Port not found: {name} ({path})")
    return _parse_port(json.loads(path.read_text(encoding="utf-8")))


def list_ports(ports_dir: Path) -> list[str]:
    if not ports_dir.is_dir():
        return []
    return sorted(p.stem for p in ports_dir.glob("*.json"))
