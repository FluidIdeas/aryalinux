"""Load ALPS configuration."""

from __future__ import annotations

from pathlib import Path

DEFAULT_CONF = Path("/etc/alps/alps.conf")
DEFAULT_DIRECTORIES = Path("/etc/alps/directories.conf")


def _parse_kv_file(conf_path: Path) -> dict[str, str]:
    config: dict[str, str] = {}
    for line in conf_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        config[key.strip()] = value.strip()
    return config


def load_config(path: Path | str = DEFAULT_CONF) -> dict[str, str]:
    conf_path = Path(path)
    if not conf_path.is_file():
        raise FileNotFoundError(f"ALPS config not found: {conf_path}")
    return _parse_kv_file(conf_path)


def load_directories(path: Path | str = DEFAULT_DIRECTORIES) -> dict[str, str]:
    """BLFS-style prefix variables (XORG_PREFIX, QT6PREFIX, etc.) for port builds."""
    dirs_path = Path(path)
    if not dirs_path.is_file():
        return {}
    return _parse_kv_file(dirs_path)
