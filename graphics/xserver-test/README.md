# X server test tool

`aryalinux-xserver-test` verifies that Xorg, Mesa/GLX, and optional desktop
sessions work for the current user.

## Install

```bash
alps -ni install xserver-test
```

Or from the build host:

```bash
graphics/xserver-test/install-xserver-test /mnt/lfs
```

## Basic smoke test

```bash
aryalinux-xserver-test
aryalinux-xserver-test --help
```

Starts display `:1` with **twm**, xclock (top-right), glxgears (lower-left), and an
xterm (upper-left). Type `exit` in the xterm (or close it) to stop the X server.

## Desktop session test

```bash
aryalinux-xserver-test --list-sessions
aryalinux-xserver-test --session xfce
aryalinux-xserver-test --session gnome
aryalinux-xserver-test --session kde
aryalinux-xserver-test --session plasmax11.desktop
```

## Cleanup

Cached files live under `~/.cache/aryalinux-xserver-test/`. The basic test
removes them automatically when the session ends. To remove them manually:

```bash
aryalinux-xserver-test --cleanup
```

## Dependencies

Installed automatically by the `xserver-test` port: `xorg-server`, `xinit`,
`twm`, `xterm`, `xclock`, and `mesa` (for `glxgears` via the BLFS xdemos patch).

Desktop sessions require the corresponding environment metapackage
(`meta.xfce`, `meta.gnome`, `meta.kde`, etc.).
