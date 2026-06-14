# AryaLinux base-system

Build scripts for a **systemd-based AryaLinux** root filesystem, aligned with **LFS 13.0** and **BLFS 13.0** (extras). Run on a prepared Linux host (Ubuntu/Debian recommended); the interactive driver is `build-arya`.

## Quick start

1. **Prepare the host**

   ```bash
   ./ubuntu-pre.sh
   ```

2. **Download sources** (into `~/sources`)

   ```bash
   ./download-sources.py      # LFS tarballs (wget-list)
   ./additional-downloads.py  # BLFS/extras, patches, ALPS bundles
   ```

3. **Start a build**

   ```bash
   ./build-arya
   ```

   Prompts show defaults in brackets; press Enter to accept. Partition paths (`ROOT_PART`, `EFI_PART`, etc.) must be set explicitly.

## Configuration

Release branding and build defaults live in **`build-defaults.json`**. Edit this file before a new release instead of changing `build-arya`:

| Field | Purpose |
|-------|---------|
| `lfs_book_version` | LFS/BLFS book version (e.g. patch URLs) |
| `os.name`, `os.version`, `os.codename` | OS identity written into `/etc/os-release`, GRUB, ISO labels |
| `locale`, `keyboard`, `paper_size` | System locale and console defaults |
| `user.*` | Default admin username, hostname, and password prompts |
| `build_options.*` | Default answers for multicore, backups, X/desktop, bootloader, live ISO |

At build time, choices are saved to **`build-properties`** (generated; not committed).

## Source lists

| File | Used by | Contents |
|------|---------|----------|
| `wget-list` | `download-sources.py` | LFS 13.0 package tarballs |
| `additional-wget-list` | `additional-downloads.py` | BLFS extras, initramfs, kernel firmware, live-ISO tools |

To add or bump a package version, update the appropriate list. Patches under `patches/` are copied (or fetched from BLFS using `lfs_book_version`) by `additional-downloads.py`.

## Bundled ALPS

`alps/` holds ALPS 3.0 (Python package manager). `additional-downloads.py` creates `alps-new-<os.version>.tar.gz` in `~/sources`; `extras/019-alps.sh` installs it during stage 7. BLFS port JSON files from `../applications/` are copied to `$LFS/var/cache/alps/ports/` in stage 1. Generate ports with `../parser/aryalinux-script-generator/generate-ports.py`.

## Directory layout

| Path | Role |
|------|------|
| `cross-toolchain/` | LFS chapter 5 — cross compiler |
| `temp-tools/` | LFS chapter 6 — temporary tools |
| `additional-temp-tools/` | LFS chapter 7 |
| `final-system/` | LFS chapter 8 — final system packages |
| `initramfs-tools/` | cpio, dash, dracut (stage 7 initramfs stack) |
| `extras/` | BLFS and AryaLinux add-ons (bootloader, CA certs, ALPS, …) |
| `apps/` | Hooks for optional desktop/application layers |
| `build-arya` | Interactive build driver (Python) |
| `stage1.sh` … `stage7.sh` | Build stages |

## Build stages (summary)

| Stage | Script | Main work |
|-------|--------|-----------|
| 1 | `stage1.sh` | Partitions, mount `$LFS`, copy sources |
| 2 | `stage2.sh` | Cross toolchain (as user `lfs`) |
| 3 | `stage3.sh` | Temporary tools |
| 4–6 | `stage4.sh` … `stage6.sh` | Chroot, final system packages |
| 7 | `stage7.sh` | `/etc` config, kernel, initramfs, extras, live ISO prep |

Resume an interrupted build with `./build-arya` → option 2.

## Source backup

After a build (or before wiping the LFS partition), save downloaded tarballs to the
build host with:

```bash
cd base-system
./backup-sources.sh
```

The script reads `build-properties`, mounts `$ROOT_PART` at `$LFS` (usually
`/mnt/lfs`), and copies archives to `~/sources`:

| Path | Contents |
|------|----------|
| `~/sources/` | LFS/BLFS book tarballs (`*.tar.*`, patches, wget lists) |
| `~/sources/alps/<port>/` | ALPS port download tarballs only (no `build/` trees) |

Restore on a new tree:

```bash
cp -a ~/sources/alps/* /mnt/lfs/var/cache/alps/sources/
cp -a ~/sources/*.tar.* /mnt/lfs/sources/    # as needed
```

Stage 1 also seeds the ALPS cache from `~/sources-apps/` if present; `backup-sources.sh`
uses `~/sources/alps/` and still merges a legacy `~/sources-apps/` tree when found.

## Regenerating from a new LFS book

The parser lives in a separate repo at `../parser/` (sibling to this `aryalinux/`
directory). Unpack LFS books under `parser/` (e.g. `parser/14.0-systemd/`), then:

```bash
cd ../parser/aryalinux-script-generator
python3 aryalinux-generate.py --book ../14.0-systemd --refresh-map --dry-run
python3 aryalinux-generate.py --book ../14.0-systemd --refresh-map
```

`--refresh-map` regenerates `package-map.yaml` from the book (tarballs, order,
script numbers) and merges existing AryaLinux hooks. Output is written to
`base-system/` in this repository. See **`../parser/aryalinux-script-generator/README.md`**.

Stage scripts (`stage4.sh`, `stage7.sh`, `ubuntu-pre.sh`, extras) are maintained by hand after generation.

## Notes

- Host **Binutils** should be ≤ 2.46.0 per LFS 13.0; newer distros may need verification.
- After renumbering final-system scripts, start a **fresh** build rather than resuming an old tree.
- **Kernel config** uses a checked-in generic amd64 config under `kernel-configs/`
  (Debian amd64 fragment + LFS + AryaLinux overlays). Regenerate with
  `parser/aryalinux-script-generator/upgrade-kernel-config.py` when the kernel version changes.
  Use `./configure-kernel.sh` on the host to review or tweak settings interactively.
- `build-properties`, `build-log`, and downloaded tarballs under `~/sources` are local build artifacts (see repo `.gitignore`).
