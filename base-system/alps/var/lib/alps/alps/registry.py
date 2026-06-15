"""Installed package records — one JSON file per package."""

from __future__ import annotations

import json
import sys
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from pathlib import Path

from .util import ensure_state_dir, remove_state_file, write_state_file


@dataclass
class InstalledPackage:
    name: str
    version: str
    installed_at: str
    files: list[str] = field(default_factory=list)
    package: str = ""
    requested: bool = False

    @classmethod
    def now(
        cls,
        name: str,
        version: str,
        files: list[str],
        package: str,
        *,
        requested: bool = False,
    ) -> InstalledPackage:
        return cls(
            name=name,
            version=version,
            installed_at=datetime.now(timezone.utc).isoformat(),
            files=sorted(files),
            package=package,
            requested=requested,
        )


def _record_from_dict(data: dict) -> InstalledPackage:
    data.setdefault("requested", False)
    return InstalledPackage(**data)


def _read_record(path: Path) -> InstalledPackage | None:
    try:
        text = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    if not text:
        print(f"warning: ignoring empty ALPS record {path}", file=sys.stderr)
        return None
    try:
        data = json.loads(text)
    except json.JSONDecodeError as exc:
        print(f"warning: ignoring invalid ALPS record {path}: {exc}", file=sys.stderr)
        return None
    return _record_from_dict(data)


def record_path(installed_dir: Path, name: str) -> Path:
    return installed_dir / f"{name}.json"


def is_installed(installed_dir: Path, name: str) -> bool:
    path = record_path(installed_dir, name)
    return _read_record(path) is not None


def load_installed(installed_dir: Path, name: str) -> InstalledPackage:
    path = record_path(installed_dir, name)
    record = _read_record(path)
    if record is None:
        raise FileNotFoundError(f"Installed record missing or invalid: {name} ({path})")
    return record


def save_installed(installed_dir: Path, record: InstalledPackage) -> None:
    ensure_state_dir(installed_dir)
    path = record_path(installed_dir, record.name)
    write_state_file(path, json.dumps(asdict(record), indent=2) + "\n")


def remove_record(installed_dir: Path, name: str) -> None:
    remove_state_file(record_path(installed_dir, name))


def list_installed(installed_dir: Path) -> list[InstalledPackage]:
    if not installed_dir.is_dir():
        return []
    records = []
    for path in sorted(installed_dir.glob("*.json")):
        record = _read_record(path)
        if record is not None:
            records.append(record)
    return records
