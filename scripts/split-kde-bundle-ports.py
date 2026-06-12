#!/usr/bin/env python3
"""Split frameworks6 and plasma-all bundle ports into individual ALPS ports."""

from __future__ import annotations

import json
import re
from pathlib import Path

APPS = Path(__file__).resolve().parents[1] / "applications"

KF6_BASE_DEPS = [
    "extra-cmake-modules",
    "breeze-icons",
    "docbook",
    "docbook-xsl",
    "libcanberra",
    "libgcrypt",
    "libical",
    "libsecret",
    "libxslt",
    "lmdb",
    "qca",
    "libqrencode",
    "plasma-wayland-protocols",
    "python-modules.PyYAML",
    "shared-mime-info",
    "perl-modules.perl-uri",
    "qt6",
]

KF6_SKIP = {"kapidox", "extra-cmake-modules", "breeze-icons"}

KF6_CMAKE_USER = (
    "cmake -B build -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \\\n"
    "      -D CMAKE_INSTALL_LIBEXECDIR=libexec \\\n"
    "      -D CMAKE_PREFIX_PATH=$QT6DIR \\\n"
    "      -D CMAKE_SKIP_INSTALL_RPATH=ON \\\n"
    "      -D CMAKE_BUILD_TYPE=Release \\\n"
    "      -D BUILD_TESTING=OFF \\\n"
    "      -D BUILD_PYTHON_BINDINGS=OFF \\\n"
    "      -W no-dev ."
)

PLASMA_BASE_DEPS = [
    "frameworks6",
    "boost",
    "gtk3",
    "kirigami-addons",
    "kquickimageeditor",
    "libdisplay-info",
    "libpwquality",
    "libxcvt",
    "wayland",
    "phonon",
    "qcoro",
    "sassc",
    "xdotool",
    "x7driver",
    "gsettings-desktop-schemas",
    "libcanberra",
    "libwacom",
    "linux-pam",
]

PLASMA_CMAKE_USER = (
    "cmake -B build -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \\\n"
    "      -D CMAKE_INSTALL_LIBEXECDIR=libexec \\\n"
    "      -D CMAKE_BUILD_TYPE=Release \\\n"
    "      -D BUILD_QT5=OFF \\\n"
    "      -D BUILD_TESTING=OFF \\\n"
    "      -W no-dev ."
)

PLASMA_POST_INSTALL = [
    "install -d /usr/share/xsessions",
    "ln -sf /usr/share/xsessions/plasmax11.desktop /usr/share/xsessions/plasma.desktop",
    "install -d /usr/share/wayland-sessions",
    "ln -sf /usr/share/wayland-sessions/plasma.desktop /usr/share/wayland-sessions/plasmawayland.desktop",
    "install -d /usr/share/xdg-desktop-portal",
    "ln -sf /usr/share/xdg-desktop-portal/kde-portals.conf /usr/share/xdg-desktop-portal/kde-portals.conf",
    "install -d /usr/share/xdg-desktop-portal/portals",
    "ln -sf /usr/share/xdg-desktop-portal/portals/kde.portal /usr/share/xdg-desktop-portal/portals/kde.portal",
    "install -vdm755 /etc/pam.d",
    "cat > /etc/pam.d/kde << 'EOF'\n# Begin /etc/pam.d/kde\n\nauth     requisite      pam_nologin.so\nauth     required       pam_env.so\n\nauth     required       pam_succeed_if.so uid >= 1000 quiet\nauth     include        system-auth\n\naccount  include        system-account\npassword include        system-password\nsession  include        system-session\n\n# End /etc/pam.d/kde\nEOF",
    "cat > /etc/pam.d/kde-np << 'EOF'\n# Begin /etc/pam.d/kde-np\n\nauth     requisite      pam_nologin.so\nauth     required       pam_env.so\n\nauth     required       pam_succeed_if.so uid >= 1000 quiet\nauth     required       pam_permit.so\n\naccount  include        system-account\npassword include        system-password\nsession  include        system-session\n\n# End /etc/pam.d/kde-np\nEOF",
    "cat > /etc/pam.d/kscreensaver << 'EOF'\n# Begin /etc/pam.d/kscreensaver\n\nauth    include system-auth\naccount include system-account\n\n# End /etc/pam.d/kscreensaver\nEOF",
]


def parse_md5_heredoc(text: str) -> list[tuple[str, str]]:
    """Return [(port_name, version), ...] from BLFS md5 list."""
    out: list[tuple[str, str]] = []
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        if len(parts) < 2:
            continue
        archive = parts[-1]
        m = re.match(r"^(.+)-(\d+\.\d+\.\d+)\.tar\.(xz|gz|bz2)$", archive)
        if not m:
            continue
        out.append((m.group(1), m.group(2)))
    return out


def write_port(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2) + "\n")


def kf6_port(name: str, version: str, deps: list[str]) -> dict:
    return {
        "name": name,
        "version": version,
        "description": f"KDE Frameworks 6 module {name}.",
        "category": "desktop-kde",
        "url": [
            f"https://download.kde.org/stable/frameworks/6.23/{name}-{version}.tar.xz"
        ],
        "dependencies": {"required": deps},
        "build": {
            "environment": {"KF6_PREFIX": "/usr"},
            "user": [KF6_CMAKE_USER, "make -C build"],
            "package": ["make -C build install DESTDIR=$DESTDIR"],
        },
        "post_install": [],
        "meta": False,
        "book": "kde/frameworks6.html",
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
    }


def plasma_port(name: str, version: str, deps: list[str], *, post_install: list[str] | None = None) -> dict:
    return {
        "name": name,
        "version": version,
        "description": f"KDE Plasma component {name}.",
        "category": "desktop-kde",
        "url": [
            f"https://download.kde.org/stable/plasma/{version}/{name}-{version}.tar.xz"
        ],
        "dependencies": {"required": deps},
        "build": {
            "environment": {"KF6_PREFIX": "/usr"},
            "user": [PLASMA_CMAKE_USER, "make -C build"],
            "package": ["make -C build install DESTDIR=$DESTDIR"],
        },
        "post_install": post_install or [],
        "meta": False,
        "book": "kde/plasma-all.html",
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
    }


def load_frameworks_packages() -> list[tuple[str, str]]:
    html = Path(
        "/home/chandrakant/aryalinux/parser/blfs-book-13.0-systemd-html/kde/frameworks6.html"
    ).read_text()
    m = re.search(
        r'frameworks-6\.23\.0\.md5.*?<code class="literal">(.*?)</code>',
        html,
        re.S,
    )
    if not m:
        raise SystemExit("frameworks md5 block not found")
    return parse_md5_heredoc(m.group(1))


def load_plasma_packages() -> list[tuple[str, str]]:
    html = Path(
        "/home/chandrakant/aryalinux/parser/blfs-book-13.0-systemd-html/kde/plasma-all.html"
    ).read_text()
    m = re.search(
        r'plasma-6\.6\.1\.md5.*?<code class=\s*"literal">(.*?)</code>',
        html,
        re.S,
    )
    if not m:
        raise SystemExit("plasma md5 block not found")
    return parse_md5_heredoc(m.group(1))


def main() -> None:
    kf6_names: list[str] = []
    prev: str | None = None
    for name, version in load_frameworks_packages():
        if name in KF6_SKIP:
            continue
        deps = list(KF6_BASE_DEPS) if prev is None else [prev]
        write_port(APPS / f"{name}.json", kf6_port(name, version, deps))
        kf6_names.append(name)
        prev = name

    frameworks_meta = {
        "name": "frameworks6",
        "version": "6.23.0",
        "description": "Metapackage: installs all KDE Frameworks 6 libraries in BLFS build order.",
        "category": "metapackage",
        "dependencies": {"required": kf6_names},
        "build": {},
        "post_install": [],
        "meta": True,
        "book": "kde/frameworks6.html",
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
    }
    write_port(APPS / "frameworks6.json", frameworks_meta)

    plasma_names: list[str] = []
    prev = None
    for name, version in load_plasma_packages():
        deps = list(PLASMA_BASE_DEPS) if prev is None else [prev]
        post = PLASMA_POST_INSTALL if name == "plasma-workspace" else []
        write_port(APPS / f"{name}.json", plasma_port(name, version, deps, post_install=post))
        plasma_names.append(name)
        prev = name

    plasma_meta = {
        "name": "plasma-all",
        "version": "6.6.1",
        "description": "Metapackage: installs all KDE Plasma desktop components in BLFS build order.",
        "category": "metapackage",
        "dependencies": {"required": plasma_names},
        "build": {},
        "post_install": [],
        "meta": True,
        "book": "kde/plasma-all.html",
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
    }
    write_port(APPS / "plasma-all.json", plasma_meta)

    print(f"frameworks6: {len(kf6_names)} ports + meta")
    print(f"plasma-all: {len(plasma_names)} ports + meta")


if __name__ == "__main__":
    main()
