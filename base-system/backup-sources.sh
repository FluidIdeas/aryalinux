#!/bin/bash
# SPDX-License-Identifier: MIT
# Backup LFS and ALPS downloaded sources to ~/sources on the build host.
#
# Reads base-system/build-properties, mounts the LFS root at $LFS (default /mnt/lfs),
# then copies:
#   - All LFS book inputs from $LFS/sources (tarballs, patches, lists, certdata, …)
#   - The full ALPS source cache from $LFS/var/cache/alps/sources/ (tarballs, patches,
#     supplementary files, per-module downloads) while skipping extracted build trees
#
# Restore ALPS cache (one shot):
#   rsync -a ~/sources/alps/ /mnt/lfs/var/cache/alps/sources/
#   # or: cp -a ~/sources/alps/* /mnt/lfs/var/cache/alps/sources/
#
# Restore LFS inputs (stage 1 also copies ~/sources/* into $LFS/sources):
#   rsync -a ~/sources/ /mnt/lfs/sources/ --exclude alps/

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

Backup downloaded LFS and ALPS sources to ~/sources.

Environment:
  SOURCES_BACKUP_DIR   Destination directory (default: ~/sources)

What is backed up:
  LFS: every file in \$LFS/sources except aryalinux/toolchain backup images
  ALPS: everything under var/cache/alps/sources except extracted build/ trees

Restore:
  rsync -a $ALPS_DEST/ /mnt/lfs/var/cache/alps/sources/
  rsync -a $DEST/ /mnt/lfs/sources/ --exclude alps/
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

count_tree_files() {
    local root="$1"
    local exclude_build="${2:-0}"
    if [ ! -d "$root" ]; then
        echo 0
        return 0
    fi
    if [ "$exclude_build" = 1 ]; then
        find "$root" -type f ! -path '*/build/*' 2>/dev/null | wc -l | tr -d ' '
    else
        find "$root" -type f 2>/dev/null | wc -l | tr -d ' '
    fi
}

copy_lfs_sources() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"
    local copied=0 skipped=0 file

    [ -d "$src_dir" ] || return 0
    mkdir -p "$dest_dir"

    while IFS= read -r -d '' file; do
        if is_lfs_backup_archive "$file"; then
            skipped=$((skipped + 1))
            continue
        fi
        if cp -a -u "$file" "$dest_dir/"; then
            copied=$((copied + 1))
        fi
    done < <(find "$src_dir" -maxdepth 1 -type f -print0 2>/dev/null)

    printf '%s: %s (%d files copied, %d backup archives skipped)\n' \
        "$label" "$dest_dir" "$copied" "$skipped" | tee -a "$MANIFEST"
}

copy_alps_sources() {
    local src_root="$1"
    local dest_root="$2"
    local label="$3"
    local src_count dest_count

    [ -d "$src_root" ] || return 0
    mkdir -p "$dest_root"
    src_count="$(count_tree_files "$src_root" 1)"

    if command -v rsync >/dev/null 2>&1; then
        # Skip extracted build trees; keep tarballs, patches, module downloads, etc.
        rsync -a \
            --exclude='build/' \
            --exclude='.cache/' \
            --exclude='__pycache__/' \
            "$src_root/" "$dest_root/"
    else
        # Fallback without rsync: mirror port trees, skipping build/ subtrees.
        local entry rel
        for entry in "$src_root"/* "$src_root"/.[!.]* "$src_root"/..?*; do
            [ -e "$entry" ] || continue
            rel="$(basename "$entry")"
            case "$rel" in
                build) continue ;;
            esac
            if [ -d "$entry" ]; then
                mkdir -p "$dest_root/$rel"
                while IFS= read -r -d '' file; do
                    cp -a -u "$file" "$dest_root/$rel/"
                done < <(find "$entry" -type f ! -path '*/build/*' -print0 2>/dev/null)
            elif [ -f "$entry" ] || [ -L "$entry" ]; then
                cp -a -u "$entry" "$dest_root/"
            fi
        done
    fi

    dest_count="$(count_tree_files "$dest_root" 1)"
    printf '%s: %s (%d source files, %d files in backup)\n' \
        "$label" "$dest_root" "$src_count" "$dest_count" | tee -a "$MANIFEST"
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

echo "Backing up LFS sources (tarballs, patches, lists, and other inputs)..."
copy_lfs_sources "$LFS/sources" "$DEST" "LFS root sources"

if [ -d "$HOME/sources" ] && [ "$HOME/sources" -ef "$DEST" ]; then
    :
elif [ -d "$HOME/sources" ]; then
    copy_lfs_sources "$HOME/sources" "$DEST" "host ~/sources"
fi

echo "Backing up ALPS source cache (archives, patches, supplementary files)..."
copy_alps_sources "$LFS/var/cache/alps/sources" "$ALPS_DEST" "ALPS source cache"

if [ -d "$HOME/sources-apps" ]; then
    echo "Merging legacy ~/sources-apps..."
    copy_alps_sources "$HOME/sources-apps" "$ALPS_DEST" "legacy ~/sources-apps"
fi

echo >>"$MANIFEST"
echo "Totals:" >>"$MANIFEST"
printf '  LFS files:  %s\n' \
    "$(find "$DEST" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')" >>"$MANIFEST"
printf '  ALPS files: %s\n' "$(count_tree_files "$ALPS_DEST" 1)" >>"$MANIFEST"

echo
echo "Backup complete."
echo "  LFS sources:   $DEST"
echo "  ALPS sources:  $ALPS_DEST/"
echo "  Manifest:      $MANIFEST"
echo
echo "Restore ALPS cache:"
echo "  rsync -a $ALPS_DEST/ $LFS/var/cache/alps/sources/"
echo "Restore LFS sources:"
echo "  rsync -a $DEST/ $LFS/sources/ --exclude alps/"
