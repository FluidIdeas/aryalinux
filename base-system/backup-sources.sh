#!/bin/bash
# SPDX-License-Identifier: MIT
# Backup LFS and ALPS downloaded source archives to ~/sources on the build host.
#
# Reads base-system/build-properties, mounts the LFS root at $LFS (default /mnt/lfs),
# then copies:
#   - LFS book tarballs from $LFS/sources and the host ~/sources
#   - ALPS port tarballs from $LFS/var/cache/alps/sources into ~/sources/alps/<port>/
#
# Restore ALPS cache (one shot):
#   cp -a ~/sources/alps/* /mnt/lfs/var/cache/alps/sources/
#
# Restore LFS tarballs (stage 1 also copies ~/sources/* into $LFS/sources):
#   cp -a ~/sources/*.tar.* ~/sources/*.tar ~/sources/wget-list ~/sources/additional-wget-list /mnt/lfs/sources/ 2>/dev/null || true

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

PROPS_FILE="${1:-./build-properties}"
DEST="${SOURCES_BACKUP_DIR:-$HOME/sources}"
ALPS_DEST="$DEST/alps"
MANIFEST="$DEST/backup-sources-manifest.txt"

usage() {
    cat <<EOF
Usage: $(basename "$0") [build-properties]

Backup downloaded LFS and ALPS source archives to ~/sources.

Environment:
  SOURCES_BACKUP_DIR   Destination directory (default: ~/sources)

Restore:
  cp -a ~/sources/alps/* /mnt/lfs/var/cache/alps/sources/
  cp -a ~/sources/*.tar.* /mnt/lfs/sources/   # as needed
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

if [ ! -f "$PROPS_FILE" ]; then
    echo "build-properties not found: $PROPS_FILE" >&2
    echo "Run from base-system/ or pass the path to build-properties." >&2
    exit 1
fi

# shellcheck disable=SC1090
. "$PROPS_FILE"

: "${ROOT_PART:?ROOT_PART is not set in $PROPS_FILE}"
LFS="${LFS:-/mnt/lfs}"

if [ ! -b "$ROOT_PART" ]; then
    echo "ROOT_PART is not a block device: $ROOT_PART" >&2
    exit 1
fi

is_lfs_backup_archive() {
    case "$(basename "$1")" in
        aryalinux-*.tar.gz | aryalinux-*.tar.xz | toolchain-*.tar.xz | toolchain-*.tar.gz)
            return 0
            ;;
    esac
    return 1
}

is_source_archive() {
    local base
    base="$(basename "$1")"
    case "$base" in
        *.iso) return 1 ;;
        *.tar | *.tar.* | *.tgz | *.txz | *.zip | *.gem | *.deb | *.rpm | *.patch)
            return 0
            ;;
    esac
    return 1
}

copy_archives() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"
    local copied=0
    local file

    [ -d "$src_dir" ] || return 0
    mkdir -p "$dest_dir"

    while IFS= read -r -d '' file; do
        if is_lfs_backup_archive "$file"; then
            continue
        fi
        if ! is_source_archive "$file"; then
            continue
        fi
        if cp -a -u "$file" "$dest_dir/"; then
            copied=$((copied + 1))
        fi
    done < <(find "$src_dir" -maxdepth 1 -type f -print0 2>/dev/null)

    printf '%s: %s (%d archives)\n' "$label" "$dest_dir" "$copied" | tee -a "$MANIFEST"
}

copy_alps_port_archives() {
    local src_root="$1"
    local dest_root="$2"
    local port_dir port copied=0 total=0 file

    [ -d "$src_root" ] || return 0
    mkdir -p "$dest_root"

    for port_dir in "$src_root"/*/; do
        [ -d "$port_dir" ] || continue
        port="$(basename "$port_dir")"
        mkdir -p "$dest_root/$port"
        copied=0
        while IFS= read -r -d '' file; do
            if is_source_archive "$file"; then
                cp -a -u "$file" "$dest_root/$port/"
                copied=$((copied + 1))
            fi
        done < <(find "$port_dir" -maxdepth 1 -type f -print0 2>/dev/null)
        if [ "$copied" -gt 0 ]; then
            total=$((total + copied))
            printf '  %s: %d archives\n' "$port" "$copied" >>"$MANIFEST"
        fi
    done

    printf 'ALPS port archives: %s (%d files)\n' "$dest_root" "$total" | tee -a "$MANIFEST"
}

copy_list_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local name

    mkdir -p "$dest_dir"
    for name in wget-list additional-wget-list; do
        if [ -f "$src_dir/$name" ]; then
            cp -a -u "$src_dir/$name" "$dest_dir/$name"
        fi
    done
}

echo "=== AryaLinux source backup $(date -Iseconds) ===" | tee "$MANIFEST"
echo "build-properties: $PROPS_FILE" >>"$MANIFEST"
echo "ROOT_PART=$ROOT_PART LFS=$LFS" >>"$MANIFEST"
echo "destination: $DEST" >>"$MANIFEST"
echo >>"$MANIFEST"

if [ -x ./umountal.sh ]; then
    ./umountal.sh || true
fi

mkdir -p "$LFS"
if ! mountpoint -q "$LFS"; then
    mount -v "$ROOT_PART" "$LFS"
fi

if [ -n "${HOME_PART:-}" ] && [ -b "$HOME_PART" ] && ! mountpoint -q "$LFS/home"; then
    mkdir -p "$LFS/home"
    mount -v "$HOME_PART" "$LFS/home"
fi

mkdir -p "$DEST" "$ALPS_DEST"

echo "Backing up LFS archives..."
copy_archives "$LFS/sources" "$DEST" "LFS root sources"
copy_list_files "$LFS/sources" "$DEST"

if [ -d "$HOME/sources" ] && [ "$HOME/sources" -ef "$DEST" ]; then
    :
elif [ -d "$HOME/sources" ]; then
    copy_archives "$HOME/sources" "$DEST" "host ~/sources"
    copy_list_files "$HOME/sources" "$DEST"
fi

echo "Backing up ALPS port archives..."
copy_alps_port_archives "$LFS/var/cache/alps/sources" "$ALPS_DEST"

if [ -d "$HOME/sources-apps" ]; then
    echo "Merging legacy ~/sources-apps..."
    copy_alps_port_archives "$HOME/sources-apps" "$ALPS_DEST"
fi

echo
echo "Backup complete."
echo "  LFS tarballs:  $DEST"
echo "  ALPS tarballs: $ALPS_DEST/<port>/"
echo "  Manifest:      $MANIFEST"
echo
echo "Restore ALPS cache:"
echo "  cp -a $ALPS_DEST/* $LFS/var/cache/alps/sources/"
echo "Restore LFS tarballs:"
echo "  cp -a $DEST/*.tar.* $LFS/sources/  # adjust globs as needed"
