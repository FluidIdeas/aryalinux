# Graphics session tools

Desktop-environment-neutral helpers for X11 display sessions on AryaLinux.

Works with KDE (plasmalogin), SDDM, LightDM, GDM, or manual `Xorg` starts.

## aryalinux-graphics-setup

```bash
sudo aryalinux-graphics-setup apply      # everyone: X11 sockets; NVIDIA+nouveau: safe X11/Mesa
sudo aryalinux-graphics-setup status
sudo aryalinux-graphics-setup remove     # drop optional snippets; keep universal socket setup
sudo aryalinux-graphics-setup restore-display-manager
```

On Intel/AMD systems, `apply` only ensures `/tmp/.X11-unix` exists and enables
`early-x11-sockets.service` from `xorg-server`.

On NVIDIA systems using **nouveau**, it also installs optional safe Xorg/Mesa
snippets. It does nothing when the proprietary `nvidia` module is loaded.

**plasmalogin note:** the Plasma login *greeter* is Wayland-only. On NVIDIA+nouveau
it often stays black. Use `aryalinux-plasma-session autologin` to boot into Plasma
on X11, or install another display manager (e.g. LightDM) for a classic login screen.

## aryalinux-graphics-diagnose

```bash
sudo aryalinux-graphics-diagnose
```

## KDE-specific session tweaks

Install `plasma-graphics-tools` for `aryalinux-plasma-session` (X11/Wayland
plasmalogin drop-in only).

## Related ports

- `xorg-server` — universal `/tmp/.X11-unix` setup at install time
- `nouveau-firmware` — optional, NVIDIA RTX 20xx/30xx with nouveau
- `plasma-graphics-tools` — KDE plasmalogin session helper
