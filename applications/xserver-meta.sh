7#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME="xserver-meta"
DESCRIPTION="meta-package to install xserver components"
VERSION=

whoami > /tmp/currentuser
sudo usermod -a -G video `cat /tmp/currentuser`

#REQ:libxml2
#REQ:util-macros
#REQ:xorgproto
#REQ:libXau
#REQ:libXdmcp
#REQ:xcb-proto
#REQ:libxcb
#REQ:x7lib
#REQ:xcb-util
#REQ:xcb-util-image
#REQ:xcb-util-keysyms
#REQ:xcb-util-renderutil
#REQ:xcb-util-wm
#REQ:xcb-util-cursor
#REQ:libva
#REQ:xbitmaps
#REQ:x7app
#REQ:xcursor-themes
#REQ:x7font
#REQ:xkeyboard-config
#REQ:mesa
#REQ:xorg-server
#REQ:x7driver
#OPT:xf86-video-mga
#OPT:xf86-video-sis
#REQ:xf86-video-cirrus
#REQ:xf86-video-mach64
#REQ:xf86-video-openchrome
#OPT:xf86-video-r128
#OPT:xf86-video-savage
#OPT:xf86-video-tdfx
#REQ:xf86-video-vesa
#REQ:libva-intel-driver
#REQ:libvdpau
#REQ:libvdpau-va-gl
#REQ:twm
#REQ:xterm
#REQ:xclock
#REQ:xinit
#REQ:wayland-protocols

sudo rm -f /etc/X11/xorg.conf.d/*

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
