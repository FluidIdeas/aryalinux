# Generic amd64 kernel configurations

Checked-in `.config` files for building a **broad-coverage** amd64 kernel (most
drivers as modules), suitable for installing AryaLinux on varied hardware.

| File | Purpose |
|------|---------|
| `linux-VERSION-amd64.config` | Full config for a specific upstream kernel |
| `current-amd64.config` | Symlink to the config matching `wget-list` |

## Regenerating

From the repo root:

```bash
cd ../parser/aryalinux-script-generator
python3 upgrade-kernel-config.py
```

After bumping the kernel tarball in `base-system/wget-list`, run the same command.
Use `--from-previous` to adapt the last config (faster, preserves local tuning).
Use `--refresh-base` to re-download the Debian or Arch upstream base.

See `parser/aryalinux-script-generator/kernel-config/sources.yaml` for download URLs.
