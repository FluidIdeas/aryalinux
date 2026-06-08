"""Shared utilities."""

from __future__ import annotations

import os
import platform
import re
import shutil
import subprocess
from pathlib import Path


def arch_tag() -> str:
    return platform.machine()


def run_cmd(
    cmd: str,
    *,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
    as_root: bool = False,
) -> None:
    full_env = os.environ.copy()
    if env:
        full_env.update(env)
    if as_root and os.geteuid() != 0:
        shell_cmd = ["sudo", "bash", "-lc", cmd]
    else:
        shell_cmd = ["bash", "-lc", cmd]
    result = subprocess.run(shell_cmd, cwd=cwd, env=full_env)
    if result.returncode != 0:
        raise RuntimeError(f"command failed ({result.returncode}): {cmd}")


def prepare_install_command(cmd: str, destdir: Path) -> str:
    dest = str(destdir)
    if "DESTDIR" in cmd or "$DESTDIR" in cmd:
        return cmd
    if re.match(r"^make install\b", cmd):
        return f"{cmd} DESTDIR={dest}"
    if re.match(r"^ninja install\b", cmd):
        return f"DESTDIR={dest} {cmd}"
    if re.match(r"^\./mach install\b", cmd):
        return f"DESTDIR={dest} {cmd}"
    if re.match(r"^pip3 install\b", cmd) and "--root" not in cmd:
        return f"{cmd} --root={dest}"
    if re.match(r"^python3 setup.py install\b", cmd) and "--root" not in cmd:
        return f"{cmd} --root={dest}"
    if any(cmd.startswith(p) for p in ("/usr", "/etc", "/var", "/opt", "mkdir -pv /", "mkdir -p /", "ln -")):
        return rewrite_system_paths(cmd, destdir)
    return cmd


def rewrite_system_paths(cmd: str, destdir: Path) -> str:
    dest = str(destdir)
    out = cmd
    for prefix in ("/opt", "/usr", "/etc", "/var", "/lib"):
        out = out.replace(prefix, f"{dest}{prefix}")
    return out


def collect_files(root: Path) -> list[str]:
    if not root.is_dir():
        return []
    files: list[str] = []
    for path in sorted(root.rglob("*")):
        if path.is_file() or path.is_symlink():
            files.append("/" + str(path.relative_to(root)))
    return files


def wget(url: str, dest_dir: Path) -> Path:
    dest_dir.mkdir(parents=True, exist_ok=True)
    filename = url.rstrip("/").split("/")[-1]
    dest = dest_dir / filename
    if dest.is_file():
        return dest
    run_cmd(f'wget -nc "{url}"', cwd=dest_dir)
    return dest


def extract_archive(archive: Path, dest_dir: Path) -> Path:
    name = archive.name
    if name.endswith(".zip"):
        run_cmd(f'unzip -o -q "{archive}"', cwd=dest_dir)
    else:
        run_cmd(f'tar --no-overwrite-dir -xf "{archive}"', cwd=dest_dir)
    entries = [p for p in dest_dir.iterdir() if p.name not in (".", "..")]
    if len(entries) == 1 and entries[0].is_dir():
        return entries[0]
    return dest_dir


def create_package_archive(staging: Path, package_path: Path) -> None:
    package_path.parent.mkdir(parents=True, exist_ok=True)
    if package_path.is_file():
        package_path.unlink()
    run_cmd(f'tar -cJf "{package_path}" -C "{staging}" .')


def extract_package(package_path: Path, target: Path = Path("/")) -> None:
    run_cmd(f'tar -xJf "{package_path}" -C "{target}"', as_root=True)


def run_install_extract(commands: list[str], *, package_path: Path) -> None:
    """Run port-defined install.extract commands ($PACKAGE is substituted)."""
    pkg = str(package_path)
    for cmd in commands:
        expanded = cmd.replace("$PACKAGE", pkg)
        run_cmd(expanded, as_root=True)


def package_commands_for(build) -> list[str]:
    """Return explicit package commands, falling back to legacy build.root."""
    if build.package:
        return list(build.package)
    if build.root:
        staging = Path("$DESTDIR")
        return [prepare_install_command(c, staging) for c in build.root]
    return []


def remove_files(files: list[str]) -> None:
    for path_str in reversed(sorted(files)):
        path = Path(path_str)
        if path.is_symlink() or path.is_file():
            if os.geteuid() == 0:
                path.unlink(missing_ok=True)
            else:
                run_cmd(f'rm -f "{path}"', as_root=True)
        elif path.is_dir():
            if os.geteuid() == 0:
                shutil.rmtree(path, ignore_errors=True)
            else:
                run_cmd(f'rm -rf "{path}"', as_root=True)


def clear_directory(path: Path) -> None:
    if not path.is_dir():
        return
    for child in path.iterdir():
        if child.is_dir():
            shutil.rmtree(child)
        else:
            child.unlink()
