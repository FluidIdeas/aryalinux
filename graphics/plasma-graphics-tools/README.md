# Plasma graphics tools

Utilities for AryaLinux KDE systems with tricky GPU/display setups (especially NVIDIA + nouveau).

## aryalinux-plasma-session

Switch Plasma Login Manager between X11 and Wayland.

```bash
sudo aryalinux-plasma-session status
sudo aryalinux-plasma-session x11        # recommended first on RTX 30xx + nouveau
sudo aryalinux-plasma-session wayland
sudo aryalinux-plasma-session interactive
```

Writes `/etc/plasmalogin.conf.d/aryalinux-session.conf` and restarts `plasmalogin`.

## aryalinux-graphics-diagnose

Collects GPU, firmware, DRM, Mesa, session, and journal information.

```bash
sudo aryalinux-graphics-diagnose
sudo aryalinux-graphics-diagnose /tmp/my-report.log
```

## Related ports

- `nouveau-firmware` — NVIDIA firmware for nouveau (RTX 20xx/30xx)
- `plasma-login-manager` — display manager
