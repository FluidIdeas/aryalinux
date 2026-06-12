"""Shared utilities."""

from __future__ import annotations

import os
import platform
import re
import shutil
import subprocess
import tempfile
from collections.abc import Iterable
from pathlib import Path


def arch_tag() -> str:
    return platform.machine()


def ensure_state_dir(path: Path) -> None:
    """Ensure an ALPS state directory exists and is writable by the build user."""
    if os.geteuid() == 0:
        path.mkdir(parents=True, exist_ok=True)
        path.chmod(0o1777)
        return
    path.mkdir(parents=True, exist_ok=True)
    if os.access(path, os.W_OK | os.X_OK):
        return
    run_cmd(f'mkdir -p "{path}" && chmod 1777 "{path}"', as_root=True)


def write_state_file(path: Path, content: str, *, mode: str = "644") -> None:
    if os.geteuid() == 0:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        path.chmod(int(mode, 8))
        return
    try:
        path.write_text(content, encoding="utf-8")
        return
    except OSError as exc:
        if exc.errno != 13:
            raise
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", delete=False) as tmp:
        tmp.write(content)
        tmp_path = tmp.name
    try:
        run_cmd(f'install -m {mode} "{tmp_path}" "{path}"', as_root=True)
    finally:
        os.unlink(tmp_path)


def remove_state_file(path: Path) -> None:
    if not path.is_file():
        return
    if os.geteuid() == 0:
        path.unlink()
        return
    try:
        path.unlink()
    except OSError as exc:
        if exc.errno != 13:
            raise
        run_cmd(f'rm -f "{path}"', as_root=True)


def _parallel_job_count() -> str:
    return str(os.cpu_count() or 1)


def _with_parallel_build_env(env: dict[str, str] | None = None) -> dict[str, str]:
    """Apply LFS-style parallel build defaults unless a port overrides them."""
    full_env = os.environ.copy()
    if env:
        full_env.update(env)
    jobs = _parallel_job_count()
    full_env.setdefault("MAKEFLAGS", f"-j{jobs}")
    full_env.setdefault("CMAKE_BUILD_PARALLEL_LEVEL", jobs)
    full_env.setdefault("NINJAFLAGS", f"-j{jobs}")
    rustc_bin = Path("/opt/rustc/bin")
    if rustc_bin.is_dir():
        path = full_env.get("PATH", "")
        rustc = str(rustc_bin)
        if rustc not in path.split(":"):
            full_env["PATH"] = f"{rustc}:{path}" if path else rustc
    return full_env


def _bash_script(cmd: str) -> str:
    """Run port commands with errexit so failed steps in loops abort the build."""
    return f"set -eo pipefail\n{cmd}"


def run_cmd(
    cmd: str,
    *,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
    as_root: bool = False,
) -> None:
    full_env = _with_parallel_build_env(env)
    script = _bash_script(cmd)
    if as_root and os.geteuid() != 0:
        shell_cmd = ["sudo", "-n", "bash", "-lc", script]
    else:
        shell_cmd = ["bash", "-lc", script]
    result = subprocess.run(shell_cmd, cwd=cwd, env=full_env)
    if result.returncode != 0:
        hint = ""
        if as_root and os.geteuid() != 0:
            hint = (
                "\nhint: run alps as root in the chroot, or enable wheel NOPASSWD "
                "in /etc/sudoers.d and run pwconv/grpconv"
            )
        raise RuntimeError(f"command failed ({result.returncode}): {cmd}{hint}")


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


_LIBTOOL_LIB_SUBDIRS = ("usr/lib", "usr/lib64", "lib", "lib64")


def libtool_finish_libdirs(libdirs: Iterable[str | Path], *, as_root: bool = False) -> None:
    """Complete libtool DESTDIR installs for directories that contain .la files."""
    if shutil.which("libtool") is None:
        return
    seen: set[str] = set()
    for item in libdirs:
        libdir = Path(item)
        key = str(libdir)
        if key in seen:
            continue
        seen.add(key)
        if not libdir.is_dir() or not any(libdir.glob("*.la")):
            continue
        run_cmd(f'libtool --finish "{libdir}"', as_root=as_root)


def libtool_finish_tree(root: Path, *, as_root: bool = False) -> None:
    """Run libtool --finish on standard libdirs under a staging tree or /."""
    libtool_finish_libdirs((root / sub for sub in _LIBTOOL_LIB_SUBDIRS), as_root=as_root)


def libtool_finish_installed_files(files: list[str], *, as_root: bool = False) -> None:
    """Run libtool --finish on libdirs that received .la files from this package."""
    libdirs = [str(Path(path).parent) for path in files if path.endswith(".la")]
    libtool_finish_libdirs(libdirs, as_root=as_root)


def collect_files(root: Path) -> list[str]:
    if not root.is_dir():
        return []
    files: list[str] = []
    for path in sorted(root.rglob("*")):
        if path.is_file() or path.is_symlink():
            files.append("/" + str(path.relative_to(root)))
    return files


def url_filename(url: str) -> str:
    return url.rstrip("/").split("/")[-1].split("?")[0]


def _wget_download(url: str, dest_dir: Path, dest: Path) -> bool:
    """Download *url* into *dest* with a visible wget progress bar."""
    dest_dir.mkdir(parents=True, exist_ok=True)
    if dest.is_file() and dest.stat().st_size > 0:
        return True
    print(f"downloading {url}", flush=True)
    result = subprocess.run(
        [
            "wget",
            "-c",
            "--progress=bar:force",
            "-O",
            dest.name,
            url,
        ],
        cwd=dest_dir,
    )
    return (
        result.returncode == 0
        and dest.is_file()
        and dest.stat().st_size > 0
    )


def wget(url: str, dest_dir: Path) -> Path:
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest = dest_dir / url_filename(url)
    if not _wget_download(url, dest_dir, dest):
        dest.unlink(missing_ok=True)
        raise RuntimeError(f"download failed: {url}")
    return dest


def wget_fallback(urls: list[str], dest_dir: Path) -> Path:
    """Try each source URL until one downloads successfully."""
    if not urls:
        raise RuntimeError("no source URLs configured")
    dest_dir.mkdir(parents=True, exist_ok=True)
    errors: list[str] = []
    for url in urls:
        dest = dest_dir / url_filename(url)
        if dest.is_file() and dest.stat().st_size > 0:
            return dest
        if _wget_download(url, dest_dir, dest):
            return dest
        dest.unlink(missing_ok=True)
        errors.append(url)
    raise RuntimeError(f"all source downloads failed: {', '.join(errors)}")


def wget_all(urls: list[str], dest_dir: Path) -> None:
    """Download every supplementary URL (patches, extra tarballs, etc.)."""
    for url in urls:
        wget(url, dest_dir)


def extract_archive(archive: Path, dest_dir: Path) -> Path:
    name = archive.name
    if name.endswith(".zip"):
        run_cmd(f'unzip -o -q "{archive}"', cwd=dest_dir)
    else:
        run_cmd(f'tar --no-overwrite-dir -xf "{archive}"', cwd=dest_dir)
    entries = [p for p in dest_dir.iterdir() if p.name not in (".", "..")]
    dirs = [p for p in entries if p.is_dir()]
    if len(dirs) == 1:
        return dirs[0]
    if len(entries) == 1 and entries[0].is_dir():
        return entries[0]
    return dest_dir


def clear_staging(staging: Path) -> None:
    """Remove a prior staging tree."""
    if staging.exists():
        if os.geteuid() == 0:
            shutil.rmtree(staging)
        else:
            try:
                shutil.rmtree(staging)
            except OSError:
                run_cmd(f'rm -rf "{staging}"', as_root=True)
    staging.mkdir(parents=True, exist_ok=True)


def restore_staging_ownership(staging: Path) -> None:
    """Hand staging back to the build user after sudo package commands."""
    uid = os.getuid()
    gid = os.getgid()
    if uid == 0:
        return
    run_cmd(f'chown -R {uid}:{gid} "{staging}"', as_root=True)


_UNSAFE_PACKAGE_ROOTS = frozenset({"bin", "sbin", "lib", "lib64"})


def assert_safe_staging_root(staging: Path) -> None:
    """Reject layouts that would replace merged-usr symlinks when extracted to /."""
    if not staging.is_dir():
        return
    unsafe = sorted(
        p.name for p in staging.iterdir() if p.name in _UNSAFE_PACKAGE_ROOTS
    )
    if unsafe:
        raise RuntimeError(
            f"unsafe staging root entries {unsafe!r} under {staging} "
            "(would overwrite /bin, /sbin, or /lib on merged-usr systems)"
        )


def assert_safe_package_archive(package_path: Path) -> None:
    """Reject package tarballs with top-level bin/sbin/lib paths."""
    result = subprocess.run(
        ["tar", "-tJf", str(package_path)],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"unable to inspect package archive {package_path}: {result.stderr.strip()}"
        )
    roots: set[str] = set()
    for line in result.stdout.splitlines():
        name = line.lstrip("./")
        if not name:
            continue
        roots.add(name.split("/", 1)[0])
    unsafe = sorted(roots & _UNSAFE_PACKAGE_ROOTS)
    if unsafe:
        raise RuntimeError(
            f"unsafe package root entries {unsafe!r} in {package_path} "
            "(would overwrite /bin, /sbin, or /lib on merged-usr systems)"
        )


def create_package_archive(staging: Path, package_path: Path) -> None:
    assert_safe_staging_root(staging)
    package_path.parent.mkdir(parents=True, exist_ok=True)
    if package_path.is_file():
        package_path.unlink()
    run_cmd(f'tar -cJf "{package_path}" -C "{staging}" .')


def extract_package(package_path: Path, target: Path = Path("/")) -> None:
    if target == Path("/"):
        assert_safe_package_archive(package_path)
    run_cmd(f'tar -xJf "{package_path}" -C "{target}"', as_root=True)


def run_install_extract(commands: list[str], *, package_path: Path) -> None:
    """Run port-defined install.extract commands ($PACKAGE is substituted)."""
    pkg = str(package_path)
    for cmd in commands:
        expanded = cmd.replace("$PACKAGE", pkg)
        if " -C /" in expanded or expanded.rstrip().endswith("-C /"):
            assert_safe_package_archive(package_path)
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
