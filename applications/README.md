# ALPS ports

JSON port definitions consumed by ALPS 3.0 (`base-system/alps/`).

- **Generate:** `parser/aryalinux-script-generator/generate-ports.py`
- **Install path on system:** `/var/cache/alps/ports/`
- **Installed records:** `/var/lib/alps/installed/<name>.json` (includes file list)

Regenerate after a BLFS book upgrade:

```bash
cd parser/aryalinux-script-generator
python3 generate-ports.py --blfs-book ../blfs-book-13.0-systemd-html --wipe
```

Refresh descriptions and categories only:

```bash
python3 enrich-ports.py --blfs-book ../blfs-book-13.0-systemd-html --force
```

Each port has `description` and `category` (see `categories.json` for the taxonomy).
