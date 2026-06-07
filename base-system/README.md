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

`alps/` holds the AryaLinux package manager layout (from `alps-new`). `additional-downloads.py` creates `alps-new-<os.version>.tar.gz` and `alps-scripts-<os.version>.tar.gz` in `~/sources`; `extras/021-alps.sh` installs them during stage 7.

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

## Regenerating LFS package scripts

Package build scripts for cross-toolchain, temp-tools, and final-system can be regenerated from an LFS HTML book using the sibling tool:

```bash
../lfs-script-generator/generate-base-system.py --dry-run
../lfs-script-generator/generate-base-system.py
```

Stage scripts (`stage4.sh`, `stage7.sh`, `ubuntu-pre.sh`, extras) are maintained by hand after generation.

## Notes

- Host **Binutils** should be ≤ 2.46.0 per LFS 13.0; newer distros may need verification.
- After renumbering final-system scripts, start a **fresh** build rather than resuming an old tree.
- **Kernel config** is derived at build time from the running host (`/proc/config.gz`, then `make olddefconfig` and `make localmodconfig`), with LFS 13.0 and AryaLinux options applied in `kernel-config.sh`. Use `./configure-kernel.sh` on the host to review or tweak settings interactively.
- `build-properties`, `build-log`, and downloaded tarballs under `~/sources` are local build artifacts (see repo `.gitignore`).
