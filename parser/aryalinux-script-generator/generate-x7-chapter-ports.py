#!/usr/bin/env python3
"""Split BLFS x7lib/x7app/x7font/x7legacy bundles into per-package ports + metas."""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

_VERSION_RE = re.compile(r"^(.+)-(\d+(?:\.\d+)+)$")

REPO = Path(__file__).resolve().parents[2]
PORTS = REPO / "applications"
XORG_ARCHIVE = "https://xorg.freedesktop.org/archive/individual"

XORG_ENV = {
    "XORG_PREFIX": "/usr",
    "XORG_CONFIG": "--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static",
}

# (md5, tarball, build_kind) — BLFS build order within each chapter
LIB_PACKAGES: list[tuple[str, str, str]] = [
    ("6ad67d4858814ac24e618b8072900664", "xtrans-1.6.0.tar.xz", "default"),
    ("b617a053d2003cc81309f4e13d01379c", "libX11-1.8.13.tar.xz", "default"),
    ("ea8149187a26e9df6dbd94a60b3d8da0", "libXext-1.3.7.tar.xz", "default"),
    ("c5cc0942ed39c49b8fcd47a427bd4305", "libFS-1.0.10.tar.xz", "default"),
    ("d1ffde0a07709654b20bada3f9abdd16", "libICE-1.1.2.tar.xz", "default"),
    ("3aeeea05091db1c69e6f768e0950a431", "libSM-1.2.6.tar.xz", "default"),
    ("ec09c90a1cfd2c0630321d366a5e7203", "libXScrnSaver-1.2.5.tar.xz", "default"),
    ("9acd189c68750b5028cf120e53c68009", "libXt-1.3.1.tar.xz", "libXt"),
    ("1ef8065f0284e76c2238770365012ab2", "libXmu-1.3.1.tar.xz", "default"),
    ("d22b838e42ac0229ddf5a3afaf23910c", "libXpm-3.5.18.tar.xz", "libXpm"),
    ("2a9793533224f92ddad256492265dd82", "libXaw-1.0.16.tar.xz", "default"),
    ("baa39ada682dd524491a165bb0dfc708", "libXfixes-6.0.2.tar.xz", "default"),
    ("132816d5efccb883bbc2bf45eb905770", "libXcomposite-0.4.7.tar.xz", "default"),
    ("4c54dce455d96e3bdee90823b0869f89", "libXrender-0.9.12.tar.xz", "default"),
    ("5ce55e952ec2d84d9817169d5fdb7865", "libXcursor-1.2.3.tar.xz", "default"),
    ("72bb73f2a07f81784ad69a39d7df1da2", "libXdamage-1.1.7.tar.xz", "default"),
    ("3cba344d6b351cf308114865afa0d91e", "libfontenc-1.1.9.tar.xz", "default"),
    ("66e03e3405d923dfaf319d6f2b47e3da", "libXfont2-2.0.7.tar.xz", "libXfont2"),
    ("d378be0fcbd1f689f9a132e0d642bc4b", "libXft-2.3.9.tar.xz", "default"),
    ("95a960c1692a83cc551979f7ffe28cf4", "libXi-1.8.2.tar.xz", "default"),
    ("5f3f5754a40730d1518233a60ba5c48e", "libXinerama-1.1.6.tar.xz", "default"),
    ("b550dfa388292a821aecdd52acecc94c", "libXrandr-1.5.5.tar.xz", "default"),
    ("5014282a08b54ec0edfa73c5cf9ae2c1", "libXres-1.2.3.tar.xz", "default"),
    ("b62dc44d8e63a67bb10230d54c44dcb7", "libXtst-1.2.5.tar.xz", "default"),
    ("8a26503185afcb1bbd2c65e43f775a67", "libXv-1.0.13.tar.xz", "default"),
    ("de4227c5722a8f5ca5748f3ef524aeee", "libXvMC-1.0.15.tar.xz", "default"),
    ("543164f1239fbe92cc0a9128d8da88e9", "libXxf86dga-1.1.7.tar.xz", "default"),
    ("bea9e3707fae6c3275769e771006fa0f", "libXxf86vm-1.1.7.tar.xz", "default"),
    ("57c7efbeceedefde006123a77a7bc825", "libpciaccess-0.18.1.tar.xz", "meson"),
    ("fa0faa5b6a8e726186c535d73712ccea", "libxkbfile-1.2.0.tar.xz", "meson"),
    ("9805be7e18f858bed9938542ed2905dc", "libxshmfence-1.3.3.tar.xz", "default"),
    ("53b72ce969745f8d3e41175d6549ce0b", "libXpresent-1.0.2.tar.xz", "default"),
]

APP_PACKAGES: list[tuple[str, str, str]] = [
    ("30f898d71a7d8e817302970f1976198c", "iceauth-1.0.10.tar.xz", "default"),
    ("7dcf5f702781bdd4aaff02e963a56270", "mkfontscale-1.2.3.tar.xz", "default"),
    ("b9efe1d21615c474b22439d41981beef", "sessreg-1.1.4.tar.xz", "default"),
    ("1d61c9f4a3d1486eff575bf233e5776c", "setxkbmap-1.3.4.tar.xz", "default"),
    ("6484cd8ee30354aaaf8f490988f5f6ef", "smproxy-1.0.8.tar.xz", "default"),
    ("9cfdec89ad7bd86bcdfda150ae995955", "xauth-1.1.5.tar.xz", "default"),
    ("37063ccf902fe3d55a90f387ed62fe1f", "xcmsdb-1.0.7.tar.xz", "default"),
    ("f97e81b2c063f6ae9b18d4b4be7543f6", "xcursorgen-1.0.9.tar.xz", "default"),
    ("700556957773d378fa16a65a4406be0a", "xdpyinfo-1.4.0.tar.xz", "default"),
    ("830a54ef3ba338013e06a1b5b012b4bd", "xdriinfo-1.0.8.tar.xz", "default"),
    ("f29d1544f8dd126a1b85e2f7f728672d", "xev-1.2.6.tar.xz", "default"),
    ("687e42aa5afaec37f14da3072651c635", "xgamma-1.0.8.tar.xz", "default"),
    ("45c7e956941194e5f06a9c7307f5f971", "xhost-1.0.10.tar.xz", "default"),
    ("8e4d14823b7cbefe1581c398c6ab0035", "xinput-1.6.4.tar.xz", "default"),
    ("b8128ff6816897bd385ca437cd2886ee", "xkbcomp-1.5.0.tar.xz", "default"),
    ("543c0535367ca30e0b0dbcfa90fefdf9", "xkbevd-1.1.6.tar.xz", "default"),
    ("07483ddfe1d83c197df792650583ff20", "xkbutils-1.0.6.tar.xz", "default"),
    ("294db9393a9d8e6613e1e3dd4fe0273f", "xkill-1.0.7.tar.xz", "default"),
    ("da5b7a39702841281e1d86b7349a03ba", "xlsatoms-1.1.4.tar.xz", "default"),
    ("ab4b3c47e848ba8c3e47c021230ab23a", "xlsclients-1.1.5.tar.xz", "default"),
    ("ba2dd3db3361e374fefe2b1c797c46eb", "xmessage-1.0.7.tar.xz", "default"),
    ("0d66e07595ea083871048c4b805d8b13", "xmodmap-1.0.11.tar.xz", "default"),
    ("ab6c9d17eb1940afcfb80a72319270ae", "xpr-1.2.0.tar.xz", "default"),
    ("5ef4784b406d11bed0fdf07cc6fba16c", "xprop-1.2.8.tar.xz", "default"),
    ("dc7680201afe6de0966c76d304159bda", "xrandr-1.5.3.tar.xz", "default"),
    ("c8629d5a0bc878d10ac49e1b290bf453", "xrdb-1.2.2.tar.xz", "default"),
    ("55003733ef417db8fafce588ca74d584", "xrefresh-1.1.0.tar.xz", "default"),
    ("18ff5cdff59015722431d568a5c0bad2", "xset-1.2.5.tar.xz", "default"),
    ("fa9a24fe5b1725c52a4566a62dd0a50d", "xsetroot-1.1.3.tar.xz", "default"),
    ("d698862e9cad153c5fefca6eee964685", "xvinfo-1.1.5.tar.xz", "default"),
    ("b0081fb92ae56510958024242ed1bc23", "xwd-1.0.9.tar.xz", "default"),
    ("c91201bc1eb5e7b38933be8d0f7f16a8", "xwininfo-1.1.6.tar.xz", "default"),
    ("3e741db39b58be4fef705e251947993d", "xwud-1.0.7.tar.xz", "default"),
]

FONT_PACKAGES: list[tuple[str, str, str]] = [
    ("a6541d12ceba004c0c1e3df900324642", "font-util-1.4.1.tar.xz", "default"),
    ("a56b1a7f2c14173f71f010225fa131f1", "encodings-1.1.0.tar.xz", "default"),
    ("dd1a744b97eb6d388d4e78b17011193e", "font-alias-1.0.6.tar.xz", "default"),
    ("546d17feab30d4e3abcf332b454f58ed", "font-adobe-utopia-type1-1.0.5.tar.xz", "default"),
    ("063bfa1456c8a68208bf96a33f472bb1", "font-bh-ttf-1.0.4.tar.xz", "default"),
    ("51a17c981275439b85e15430a3d711ee", "font-bh-type1-1.0.4.tar.xz", "default"),
    ("00f64a84b6c9886040241e081347a853", "font-ibm-type1-1.0.4.tar.xz", "default"),
    ("fe972eaf13176fa9aa7e74a12ecc801a", "font-misc-ethiopic-1.0.5.tar.xz", "default"),
    ("3b47fed2c032af3a32aad9acc1d25150", "font-xfree86-type1-1.0.5.tar.xz", "default"),
]

# (md5, subdir, tarball, build_kind)
LEGACY_PACKAGES: list[tuple[str, str, str, str]] = [
    ("e09b61567ab4a4d534119bba24eddfb1", "util", "bdftopcf-1.1.1.tar.xz", "default"),
    ("20239f6f99ac586f10360b0759f73361", "font", "font-adobe-100dpi-1.0.4.tar.xz", "default"),
    ("2dc044f693ee8e0836f718c2699628b9", "font", "font-adobe-75dpi-1.0.4.tar.xz", "default"),
    ("2c939d5bd4609d8e284be9bef4b8b330", "font", "font-jis-misc-1.0.4.tar.xz", "default"),
    ("6300bc99a1e45fbbe6075b3de728c27f", "font", "font-daewoo-misc-1.0.4.tar.xz", "default"),
    ("fe2c44307639062d07c6e9f75f4d6a13", "font", "font-isas-misc-1.0.4.tar.xz", "default"),
    ("145128c4b5f7820c974c8c5b9f6ffe94", "font", "font-misc-misc-1.1.3.tar.xz", "default"),
]

LIB_EXTRA_DEPS: dict[str, list[str]] = {
    "xtrans": ["libxcb"],
    "libX11": ["libxcb"],
    "libXfont2": ["freetype2"],
    "libXft": ["fontconfig"],
    "libxkbfile": ["libxcb"],
}

APP_EXTRA_DEPS: dict[str, list[str]] = {
    "iceauth": ["libpng", "mesa", "xcb-util", "x7lib"],
}

FONT_EXTRA_DEPS: dict[str, list[str]] = {
    "font-util": ["xcursor-themes"],
}

LEGACY_EXTRA_DEPS: dict[str, list[str]] = {
    "bdftopcf": ["font-util"],
}


def _stem_parts(tarball: str) -> tuple[str, str]:
    stem = tarball.replace(".tar.xz", "")
    match = _VERSION_RE.match(stem)
    if match:
        return match.group(1), match.group(2)
    return stem, "0"


def port_name(tarball: str) -> str:
    return _stem_parts(tarball)[0]


def port_version(tarball: str) -> str:
    return _stem_parts(tarball)[1]


def build_steps(kind: str, version: str) -> tuple[list[str], list[str]]:
    if kind == "meson":
        user = [
            "rm -rf build",
            "meson setup build --prefix=$XORG_PREFIX --buildtype=release",
            "ninja -C build",
        ]
        package = ["DESTDIR=$DESTDIR ninja -C build install"]
    elif kind == "libXfont2":
        user = [
            f"./configure $XORG_CONFIG --disable-devel-docs "
            f"--docdir=/usr/share/doc/libXfont2-{version}",
            "make",
        ]
        package = ["make install DESTDIR=$DESTDIR"]
    elif kind == "libXt":
        user = [
            "./configure $XORG_CONFIG --with-appdefaultdir=/etc/X11/app-defaults",
            "make",
        ]
        package = ["make install DESTDIR=$DESTDIR"]
    elif kind == "libXpm":
        user = ["./configure $XORG_CONFIG --disable-open-zfile", "make"]
        package = ["make install DESTDIR=$DESTDIR"]
    else:
        user = ["./configure $XORG_CONFIG", "make"]
        package = ["make install DESTDIR=$DESTDIR"]
    return user, package


def write_port(
    *,
    name: str,
    version: str,
    description: str,
    url: str,
    required: list[str],
    user: list[str],
    package: list[str],
    book: str,
) -> None:
    port: dict[str, Any] = {
        "name": name,
        "version": version,
        "description": description,
        "url": [url],
        "dependencies": {"required": required},
        "build": {
            "environment": dict(XORG_ENV),
            "user": user,
            "package": package,
        },
        "post_install": [],
        "meta": False,
        "book": book,
        "category": "x11",
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
    }
    path = PORTS / f"{name}.json"
    path.write_text(json.dumps(port, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {path.name}")


def write_meta(
    *,
    name: str,
    version: str,
    description: str,
    required: list[str],
    recommended: list[str] | None = None,
    post_install: list[str] | None = None,
    book: str,
) -> None:
    deps: dict[str, list[str]] = {"required": list(required)}
    if recommended:
        for item in recommended:
            if item not in deps["required"]:
                deps["required"].append(item)
    meta: dict[str, Any] = {
        "name": name,
        "version": version,
        "description": description,
        "category": "metapackage",
        "dependencies": deps,
        "build": {},
        "install": {"extract": ["tar -xJf $PACKAGE -C /"]},
        "post_install": post_install or [],
        "meta": True,
        "book": book,
    }
    (PORTS / f"{name}.json").write_text(json.dumps(meta, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {name}.json (meta, {len(required)} entries)")


def generate_chapter(
    packages: list[tuple[str, str, str]],
    *,
    url_dir: str,
    chapter_label: str,
    extra_deps: dict[str, list[str]],
    book_prefix: str = "x",
) -> list[str]:
    names: list[str] = []
    prev: str | None = None
    base = f"{XORG_ARCHIVE}/{url_dir}"

    for _md5, tarball, kind in packages:
        name = port_name(tarball)
        version = port_version(tarball)
        names.append(name)

        required: list[str] = []
        if prev:
            required.append(prev)
        for extra in extra_deps.get(name, []):
            if extra not in required:
                required.append(extra)

        user, package = build_steps(kind, version)
        write_port(
            name=name,
            version=version,
            description=f"Xorg {chapter_label} {name} (BLFS chapter).",
            url=f"{base}/{tarball}",
            required=required,
            user=user,
            package=package,
            book=f"{book_prefix}/{name}.html",
        )
        prev = name
    return names


def generate_legacy() -> list[str]:
    names: list[str] = []
    prev: str | None = None

    for _md5, subdir, tarball, kind in LEGACY_PACKAGES:
        name = port_name(tarball)
        version = port_version(tarball)
        names.append(name)

        required: list[str] = []
        if prev:
            required.append(prev)
        for extra in LEGACY_EXTRA_DEPS.get(name, []):
            if extra not in required:
                required.append(extra)

        user, package = build_steps(kind, version)
        write_port(
            name=name,
            version=version,
            description=f"Xorg legacy {name} (BLFS x7legacy chapter).",
            url=f"{XORG_ARCHIVE}/{subdir}/{tarball}",
            required=required,
            user=user,
            package=package,
            book=f"x/{name}.html",
        )
        prev = name
    return names


def main() -> None:
    lib_names = generate_chapter(
        LIB_PACKAGES,
        url_dir="lib",
        chapter_label="library",
        extra_deps=LIB_EXTRA_DEPS,
    )
    write_meta(
        name="x7lib",
        version="7",
        description=(
            "BLFS Xorg Libraries chapter — metapackage installing all lib* "
            "components in dependency order."
        ),
        required=["fontconfig", *lib_names],
        book="x/x7lib.html",
    )

    app_names = generate_chapter(
        APP_PACKAGES,
        url_dir="app",
        chapter_label="application",
        extra_deps=APP_EXTRA_DEPS,
    )
    write_meta(
        name="x7app",
        version="7",
        description=(
            "BLFS Xorg Applications chapter — metapackage installing all "
            "X11 apps in dependency order."
        ),
        required=app_names,
        post_install=["rm -f /usr/bin/xkeystone"],
        book="x/x7app.html",
    )

    font_names = generate_chapter(
        FONT_PACKAGES,
        url_dir="font",
        chapter_label="font",
        extra_deps=FONT_EXTRA_DEPS,
    )
    write_meta(
        name="x7font",
        version="7",
        description=(
            "BLFS Xorg Fonts chapter — metapackage installing scalable font "
            "packages in dependency order."
        ),
        required=font_names,
        post_install=[
            "install -d /usr/share/fonts",
            "ln -sf /usr/share/fonts/X11/OTF /usr/share/fonts/X11-OTF",
            "ln -sf /usr/share/fonts/X11/TTF /usr/share/fonts/X11-TTF",
        ],
        book="x/x7font.html",
    )

    legacy_names = generate_legacy()
    write_meta(
        name="x7legacy",
        version="7",
        description=(
            "BLFS Xorg Legacy Fonts chapter — bitmap fonts and bdftopcf for "
            "packages that still require them."
        ),
        required=["x7font", *legacy_names],
        book="x/x7legacy.html",
    )


if __name__ == "__main__":
    main()
