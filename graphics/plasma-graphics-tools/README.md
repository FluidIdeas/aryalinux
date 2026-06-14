# Plasma graphics tools

KDE Plasma / SDDM session helpers. For GPU-agnostic X11 setup see `graphics-session-tools`.

## aryalinux-plasma-session

```bash
sudo aryalinux-plasma-session status
sudo aryalinux-plasma-session x11
sudo aryalinux-plasma-session autologin aryalinux plasmax11.desktop
sudo aryalinux-plasma-session clear-autologin
sudo aryalinux-plasma-session interactive
```

Writes `/etc/sddm.conf.d/aryalinux-session.conf` (or a plasmalogin drop-in if that DM is enabled).

## Related ports

- `graphics-session-tools` — `aryalinux-graphics-setup`, `aryalinux-graphics-diagnose`
- `sddm` — default KDE display manager (X11 greeter)
- `nouveau-firmware` — NVIDIA firmware for nouveau (optional)
