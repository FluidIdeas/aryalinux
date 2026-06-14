#!/usr/bin/env python3
"""Embed graphics/plasma-graphics-tools shell scripts into applications/plasma-graphics-tools.json."""

from __future__ import annotations

import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
TOOLS = REPO / "graphics" / "plasma-graphics-tools"
PORT = REPO / "applications" / "plasma-graphics-tools.json"

INSTALL_SCRIPTS = [
    "aryalinux-plasma-session",
    "aryalinux-kde-login-diagnose",
    "aryalinux-kde-login-fix",
    "aryalinux-plasma-restart",
]


def embed_script(name: str) -> str:
    body = (TOOLS / name).read_text(encoding="utf-8")
    escaped = body.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
    return (
        f'install -d $DESTDIR/usr/bin\n'
        f'cat > $DESTDIR/usr/bin/{name} << \'ARYALINUX_EOF\'\n'
        f'{escaped}\n'
        f'ARYALINUX_EOF\n'
        f'chmod 755 $DESTDIR/usr/bin/{name}'
    )


def main() -> None:
    data = json.loads(PORT.read_text(encoding="utf-8"))
    packages = [embed_script(name) for name in INSTALL_SCRIPTS]
    readme = (TOOLS / "README.md").read_text(encoding="utf-8").replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
    packages.append(
        "install -d $DESTDIR/usr/share/doc/plasma-graphics-tools-1.0\n"
        f'cat > $DESTDIR/usr/share/doc/plasma-graphics-tools-1.0/README.md << \'ARYALINUX_EOF\'\n'
        f'{readme}\n'
        f'ARYALINUX_EOF\n'
        f'chmod 644 $DESTDIR/usr/share/doc/plasma-graphics-tools-1.0/README.md'
    )
    data["build"]["package"] = packages
    data["description"] = (
        "KDE Plasma / SDDM session helpers and black-screen fix tools."
    )
    PORT.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    print(f"Updated {PORT} with {len(INSTALL_SCRIPTS)} scripts")


if __name__ == "__main__":
    main()
