"""Load ALPS configuration."""

from __future__ import annotations

from pathlib import Path

DEFAULT_CONF = Path("/etc/alps/alps.conf")


def load_config(path: Path | str = DEFAULT_CONF) -> dict[str, str]:
    config: dict[str, str] = {}
    conf_path = Path(path)
    if not conf_path.is_file():
        raise FileNotFoundError(f"ALPS config not found: {conf_path}")
    for line in conf_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        config[key.strip()] = value.strip()
    return config
