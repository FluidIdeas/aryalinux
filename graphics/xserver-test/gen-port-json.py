#!/usr/bin/env python3
"""Regenerate applications/xserver-test.json from graphics/xserver-test/."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent

script = (HERE / "aryalinux-xserver-test").read_text(encoding="utf-8")
readme = (HERE / "README.md").read_text(encoding="utf-8")

install_script = (
    "install -d $DESTDIR/usr/bin\n"
    "install -d $DESTDIR/usr/share/doc/xserver-test-1.0\n"
    f"cat > $DESTDIR/usr/bin/aryalinux-xserver-test << 'ARYALINUX_EOF'\n{script}ARYALINUX_EOF\n"
    "chmod 755 $DESTDIR/usr/bin/aryalinux-xserver-test\n"
    f"cat > $DESTDIR/usr/share/doc/xserver-test-1.0/README.md << 'ARYALINUX_EOF'\n{readme}ARYALINUX_EOF\n"
    "chmod 644 $DESTDIR/usr/share/doc/xserver-test-1.0/README.md"
)

port = {
    "name": "xserver-test",
    "version": "1.0",
    "description": (
        "User-space Xorg smoke test: xterm, xclock, glxgears, "
        "or a desktop session via startx."
    ),
    "category": "x11",
    "url": [],
    "dependencies": {
        "required": ["mesa", "xclock", "xinit", "xorg-server", "xterm"],
        "optional": ["xdotool"],
    },
    "build": {"package": [install_script]},
    "post_install": [],
    "meta": False,
    "book": "x/xorg-server.html",
    "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
}

out = ROOT / "applications" / "xserver-test.json"
out.write_text(json.dumps(port, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"wrote {out}")
