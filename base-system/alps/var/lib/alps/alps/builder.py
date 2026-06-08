"""Build ports into binary tarballs using explicit package commands."""

from __future__ import annotations

from pathlib import Path

from .port import Port, PortBuildModule
from .util import (
    arch_tag,
    collect_files,
    create_package_archive,
    extract_archive,
    package_commands_for,
    run_cmd,
    wget,
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
    if staging.exists():
        for child in staging.iterdir():
            if child.is_dir():
                run_cmd(f'rm -rf "{child}"')
            else:
                child.unlink()
    else:
        staging.mkdir(parents=True, exist_ok=True)

    source_root = sources_dir / port.name
    source_root.mkdir(parents=True, exist_ok=True)

    if port.build.modules:
        for module in port.build.modules:
            _build_module(module, source_root=source_root, staging=staging, env=port.build.environment)
    else:
        _build_single(port, source_root=source_root, staging=staging)

    files = collect_files(staging)
    package_path = packages_dir / package_filename(port.name, port.version)
    create_package_archive(staging, package_path)
    return package_path, files


def _env_with_staging(staging: Path, extra: dict[str, str]) -> dict[str, str]:
    env = {"DESTDIR": str(staging)}
    env.update(extra)
    return env


def _run_package_commands(
    commands: list[str],
    *,
    cwd: Path,
    staging: Path,
    env: dict[str, str],
) -> None:
    merged = _env_with_staging(staging, env)
    for cmd in commands:
        run_cmd(cmd, cwd=cwd, env=merged, as_root=True)


def _download_patches(port: Port, source_root: Path) -> None:
    for url in port.patches:
        wget(url, source_root)


def _build_single(port: Port, *, source_root: Path, staging: Path) -> None:
    build_dir = source_root / "build"
    build_dir.mkdir(parents=True, exist_ok=True)
    _download_patches(port, source_root)

    if port.url:
        archive = wget(port.url, source_root)
        srcdir = extract_archive(archive, build_dir)
    else:
        srcdir = build_dir

    for url in port.urls:
        wget(url, source_root)

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
    archive = wget(module.url, mod_dir)
    srcdir = extract_archive(archive, mod_dir)
    _run_commands(module.pre, cwd=srcdir, env=env, as_root=False)
    _run_commands(module.user, cwd=srcdir, env=env, as_root=False)
    package_cmds = module.package or module.root
    if not package_cmds:
        raise BuildError(f"{module.name}: no package commands defined")
    _run_package_commands(package_cmds, cwd=srcdir, staging=staging, env=env)
