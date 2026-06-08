"""Installed package records — one JSON file per package."""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from pathlib import Path


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


def record_path(installed_dir: Path, name: str) -> Path:
    return installed_dir / f"{name}.json"


def is_installed(installed_dir: Path, name: str) -> bool:
    return record_path(installed_dir, name).is_file()


def load_installed(installed_dir: Path, name: str) -> InstalledPackage:
    path = record_path(installed_dir, name)
    data = json.loads(path.read_text(encoding="utf-8"))
    return _record_from_dict(data)


def save_installed(installed_dir: Path, record: InstalledPackage) -> None:
    installed_dir.mkdir(parents=True, exist_ok=True)
    path = record_path(installed_dir, record.name)
    path.write_text(json.dumps(asdict(record), indent=2) + "\n", encoding="utf-8")


def remove_record(installed_dir: Path, name: str) -> None:
    path = record_path(installed_dir, name)
    if path.is_file():
        path.unlink()


def list_installed(installed_dir: Path) -> list[InstalledPackage]:
    if not installed_dir.is_dir():
        return []
    records = []
    for path in sorted(installed_dir.glob("*.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        records.append(_record_from_dict(data))
    return records
