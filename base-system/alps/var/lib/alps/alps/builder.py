"""Build ports into binary tarballs using explicit package commands."""

from __future__ import annotations

import re
import shutil
from pathlib import Path

from .port import Port, PortBuildModule, _url_list
from .util import (
    arch_tag,
    clear_directory,
    clear_staging,
    collect_files,
    create_package_archive,
    extract_archive,
    libtool_finish_tree,
    package_commands_for,
    run_cmd,
    url_filename,
    wget_all,
    wget_fallback,
)


class BuildError(Exception):
    pass


def package_filename(name: str, version: str) -> str:
    return f"{name}-{version}-{arch_tag()}.tar.xz"


def build_port(
    port: Port,
    *,
    sources_dir: Path,
    staging_dir: Path,
    packages_dir: Path,
) -> tuple[Path, list[str]]:
    if port.meta:
        return Path(), []

    staging = staging_dir / f"{port.name}-{port.version}"
    clear_staging(staging)

    source_root = sources_dir / port.name
    source_root.mkdir(parents=True, exist_ok=True)

    if port.build.modules:
        for module in port.build.modules:
            _build_module(module, source_root=source_root, staging=staging, env=port.build.environment)
    else:
        _build_single(port, source_root=source_root, staging=staging)

    libtool_finish_tree(staging)
    files = collect_files(staging)
    if not files:
        raise BuildError(
            f"{port.name}: staging directory is empty after build.package "
            f"(check DESTDIR handling)"
        )
    package_path = packages_dir / package_filename(port.name, port.version)
    create_package_archive(staging, package_path)
    return package_path, files


def _env_with_staging(staging: Path, extra: dict[str, str]) -> dict[str, str]:
    env = {"DESTDIR": str(staging)}
    env.update(extra)
    return env


def _expand_destdir(cmd: str, staging: Path) -> str:
    """Inline staging path into the command string."""
    return cmd.replace("$DESTDIR", str(staging))


def _prepare_package_cmd(cmd: str, staging: Path) -> str:
    """Expand DESTDIR and adjust packaging commands for staging installs."""
    expanded = _expand_destdir(cmd, staging)
    if (
        re.match(r"^pip3 install\b", expanded)
        and "--root=" in expanded
        and "--ignore-installed" not in expanded
    ):
        expanded = f"{expanded} --ignore-installed"
    return expanded


def _run_package_commands(
    commands: list[str],
    *,
    cwd: Path,
    staging: Path,
    env: dict[str, str],
) -> None:
    merged = _env_with_staging(staging, env)
    for cmd in commands:
        # DESTDIR installs go into the build user's staging tree; sudo is not
        # needed and breaks non-interactive builds when PAM/sudo require a tty.
        run_cmd(_prepare_package_cmd(cmd, staging), cwd=cwd, env=merged, as_root=False)


def _download_supplementary(port: Port, source_root: Path) -> None:
    if port.additional_urls:
        wget_all(port.additional_urls, source_root)


def _place_supplementary_beside_srcdir(
    port: Port, *, source_root: Path, build_dir: Path,
) -> None:
    """Place patches next to the extracted tree (BLFS ../patch layout)."""
    for url in port.additional_urls:
        name = url_filename(url)
        src = source_root / name
        if src.is_file():
            shutil.copy2(src, build_dir / name)


def _build_single(port: Port, *, source_root: Path, staging: Path) -> None:
    build_dir = source_root / "build"
    build_dir.mkdir(parents=True, exist_ok=True)
    _download_supplementary(port, source_root)

    if port.source_urls:
        archive = wget_fallback(port.source_urls, source_root)
        clear_directory(build_dir)
        srcdir = extract_archive(archive, build_dir)
        _place_supplementary_beside_srcdir(
            port, source_root=source_root, build_dir=build_dir,
        )
    else:
        srcdir = build_dir

    _run_commands(port.build.pre, cwd=srcdir, env=port.build.environment, as_root=False)
    _run_commands(port.build.user, cwd=srcdir, env=port.build.environment, as_root=False)
    package_cmds = package_commands_for(port.build)
    if not package_cmds:
        raise BuildError(f"{port.name}: no build.package commands defined")
    _run_package_commands(
        package_cmds, cwd=srcdir, staging=staging, env=port.build.environment,
    )


def _run_commands(
    commands: list[str],
    *,
    cwd: Path,
    env: dict[str, str],
    as_root: bool,
) -> None:
    for cmd in commands:
        run_cmd(cmd, cwd=cwd, env=env, as_root=as_root)


def _build_module(
    module: PortBuildModule,
    *,
    source_root: Path,
    staging: Path,
    env: dict[str, str],
) -> None:
    mod_dir = source_root / module.name.replace(".", "_")
    mod_dir.mkdir(parents=True, exist_ok=True)
    archive = wget_fallback(_url_list(module.url), mod_dir)
    srcdir = extract_archive(archive, mod_dir)
    _run_commands(module.pre, cwd=srcdir, env=env, as_root=False)
    _run_commands(module.user, cwd=srcdir, env=env, as_root=False)
    package_cmds = module.package or module.root
    if not package_cmds:
        raise BuildError(f"{module.name}: no package commands defined")
    _run_package_commands(package_cmds, cwd=srcdir, staging=staging, env=env)
