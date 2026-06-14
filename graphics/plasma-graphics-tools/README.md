# Plasma graphics tools

KDE Plasma / SDDM session helpers. For GPU-agnostic X11 setup see `graphics-session-tools`.

## Install onto a live system (from build host)

With the AryaLinux root mounted at `/mnt/lfs`:

```bash
graphics/plasma-graphics-tools/install-kde-tools /mnt/lfs
```

## On the live AryaLinux system

```bash
su -c aryalinux-kde-login-fix
reboot
```

If you still get a black desktop after login (from a text console, Ctrl+Alt+F3):

```bash
su -c aryalinux-plasma-restart
```

**Do not run `plasmashell` as root** — it will crash with ABRT. The restart tool runs it as your desktop user.

## Tools

| Command | Purpose |
|---------|---------|
| `aryalinux-kde-login-fix` | SDDM breeze theme, Qt6 paths, Plasma X11, disable KWin compositing |
| `aryalinux-kde-login-diagnose` | Write `/var/log/aryalinux-kde-login-diagnose.txt` |
| `aryalinux-plasma-restart` | Restart `kwin_x11` + `plasmashell` as desktop user |
| `aryalinux-plasma-session` | SDDM X11/Wayland drop-in, autologin |
| `aryalinux-graphics-setup` | X11 sockets + nouveau-safe Xorg (from graphics-session-tools) |
| `aryalinux-graphics-diagnose` | General graphics report |

## Related ports

- `graphics-session-tools` — `aryalinux-graphics-setup`, `aryalinux-graphics-diagnose`
- `sddm` — default KDE display manager
- `xcb-util-cursor` — required by Qt 6.5+ for the xcb platform plugin (via `xcb-utilities`)
- `nouveau-firmware` — NVIDIA firmware for nouveau (optional)
