"""ALPS command-line interface."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from . import __version__
from .config import load_config
from .fetch import fetch_ports
from .installer import (
    format_force_install_plan,
    format_install_plan,
    force_install_packages,
    install_packages,
    packages_needing_update,
    remove_package,
)
from .orphans import find_orphans, print_orphan_notice
from .port import list_ports, load_port
from .registry import list_installed
from .util import clear_directory, ensure_state_dir


HELP = f"""alps {__version__} — AryaLinux Package System

Commands:
  install [pkg ...]     Build and install packages (with dependencies)
                        --force: install named packages only (no deps, not tracked)
  remove <pkg>          Remove an installed package by file list
  update [pkg ...]      Reinstall packages with newer port versions
  update-all            Update all outdated installed packages
  list-installed        Show installed packages
  list-ports            Show available ports
  orphans               List dependency-only packages no longer needed
  info <pkg>            Show port metadata
  fetch-ports [dir]     Copy ports from a directory into PORTS_DIR
  clear-sources         Remove downloaded source trees
  clear-packages        Remove built binary tarballs
  clear-staging         Remove build staging directories
  clear-all             Clear sources, packages, and staging
"""


def _config_paths(config: dict[str, str]) -> dict[str, Path]:
    return {k: Path(config[k]) for k in (
        "PORTS_DIR", "SOURCES_DIR", "PACKAGES_DIR", "STAGING_DIR", "INSTALLED_DIR",
    )}


def _confirm_default_yes(prompt: str) -> bool:
    """Return False only when the user explicitly answers no."""
    answer = input(prompt).strip().lower()
    return answer not in ("n", "no")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="alps", add_help=False)
    parser.add_argument("command", nargs="?", default="help")
    parser.add_argument("packages", nargs="*")
    parser.add_argument("-ni", "--no-interactive", action="store_true")
    parser.add_argument("-r", "--with-recommended", action="store_true")
    parser.add_argument(
        "-f", "--force",
        action="store_true",
        help="install named packages only; skip dependencies and ALPS tracking",
    )
    parser.add_argument("--help", action="store_true")
    args = parser.parse_args(argv)

    if args.help or args.command in ("help", "-h"):
        print(HELP)
        return 0

    try:
        config = load_config()
    except FileNotFoundError as exc:
        print(exc, file=sys.stderr)
        return 1

    paths = _config_paths(config)
    for key, path in paths.items():
        if key in ("SOURCES_DIR", "PACKAGES_DIR", "STAGING_DIR", "INSTALLED_DIR", "PORTS_DIR"):
            ensure_state_dir(path)
        else:
            path.mkdir(parents=True, exist_ok=True)

    cmd = args.command
    pkgs = args.packages

    try:
        if cmd == "install":
            if not pkgs:
                print("usage: alps install <package> [package ...]", file=sys.stderr)
                return 1
            if args.force:
                if not args.no_interactive:
                    print(format_force_install_plan(config, pkgs))
                    print_orphan_notice(config)
                    if not _confirm_default_yes("Continue with force install? [Y/n] "):
                        print("Aborted.")
                        return 0
                force_install_packages(config, pkgs)
            else:
                if not args.no_interactive:
                    report = format_install_plan(
                        config,
                        pkgs,
                        include_recommended=args.with_recommended,
                        user_targets=set(pkgs),
                    )
                    print(report.text)
                    if not report.can_proceed:
                        return 0
                    print_orphan_notice(config)
                    if not _confirm_default_yes("Continue? [Y/n] "):
                        print("Aborted.")
                        return 0
                install_packages(
                    config, pkgs,
                    include_recommended=args.with_recommended,
                    user_targets=set(pkgs),
                )
        elif cmd == "remove":
            if len(pkgs) != 1:
                print("usage: alps remove <package>", file=sys.stderr)
                return 1
            remove_package(config, pkgs[0])
        elif cmd == "update":
            targets = pkgs or packages_needing_update(config)
            if not targets:
                print("No packages need updating.")
                return 0
            install_packages(config, targets, force=True, include_recommended=args.with_recommended)
        elif cmd == "update-all":
            targets = packages_needing_update(config)
            if not targets:
                print("No packages need updating.")
                return 0
            install_packages(config, targets, force=True, include_recommended=args.with_recommended)
        elif cmd == "list-installed":
            for rec in list_installed(paths["INSTALLED_DIR"]):
                reason = "user" if rec.requested else "dependency"
                print(
                    f"{rec.name}\t{rec.version}\t{reason}\t"
                    f"{rec.installed_at}\t{len(rec.files)} files"
                )
        elif cmd == "orphans":
            orphans = find_orphans(paths["PORTS_DIR"], paths["INSTALLED_DIR"])
            if not orphans:
                print("No unneeded dependency packages.")
            else:
                for name in orphans:
                    print(name)
        elif cmd == "list-ports":
            for name in list_ports(paths["PORTS_DIR"]):
                print(name)
        elif cmd == "info":
            if len(pkgs) != 1:
                print("usage: alps info <package>", file=sys.stderr)
                return 1
            port = load_port(paths["PORTS_DIR"], pkgs[0])
            print(f"name: {port.name}")
            print(f"version: {port.version}")
            if port.category:
                print(f"category: {port.category}")
            if port.description:
                print(f"description: {port.description}")
            if port.source_urls:
                print(f"url: {', '.join(port.source_urls)}")
            if port.additional_urls:
                print(f"additionalUrls: {', '.join(port.additional_urls)}")
            if port.dependencies.required:
                print(f"required: {', '.join(port.dependencies.required)}")
            if port.dependencies.pre:
                print(f"pre: {', '.join(port.dependencies.pre)}")
            if port.dependencies.post:
                print(f"post: {', '.join(port.dependencies.post)}")
            if port.dependencies.rebuild_after:
                print(f"rebuild_after: {', '.join(port.dependencies.rebuild_after)}")
            print(f"meta: {port.meta}")
        elif cmd == "fetch-ports":
            if not pkgs:
                print("usage: alps fetch-ports <source-directory>", file=sys.stderr)
                return 1
            source = Path(pkgs[0])
            count = fetch_ports(paths["PORTS_DIR"], source)
            print(f"Fetched {count} ports into {paths['PORTS_DIR']}")
        elif cmd == "clear-sources":
            clear_directory(paths["SOURCES_DIR"])
            print(f"Cleared {paths['SOURCES_DIR']}")
        elif cmd == "clear-packages":
            clear_directory(paths["PACKAGES_DIR"])
            print(f"Cleared {paths['PACKAGES_DIR']}")
        elif cmd == "clear-staging":
            clear_directory(paths["STAGING_DIR"])
            print(f"Cleared {paths['STAGING_DIR']}")
        elif cmd == "clear-all":
            for key in ("SOURCES_DIR", "PACKAGES_DIR", "STAGING_DIR"):
                clear_directory(paths[key])
            print("Cleared sources, packages, and staging.")
        else:
            print(f"Unknown command: {cmd}", file=sys.stderr)
            print(HELP)
            return 1
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    return 0
