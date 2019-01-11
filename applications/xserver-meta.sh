#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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
#REQ:mesa
#REQ:libva
#REQ:xbitmaps
#REQ:x7app
#REQ:xcursor-themes
#REQ:x7font
#REQ:xkeyboard-config
#REQ:xorg-server
#REQ:x7driver
#REQ:#OPT:xf86-video-mga
#REQ:#OPT:xf86-video-sis
#REQ:xf86-video-cirrus
#REQ:xf86-video-mach64
#REQ:xf86-video-openchrome
#REQ:#OPT:xf86-video-r128
#REQ:#OPT:xf86-video-savage
#REQ:#OPT:xf86-video-tdfx
#REQ:xf86-video-vesa
#REQ:libva-intel-driver
#REQ:libvdpau
#REQ:libvdpau-va-gl
#REQ:twm
#REQ:xterm
#REQ:xclock
#REQ:xinit
#REQ:wayland-protocols

cd $SOURCE_DIR


NAME=xserver-meta
VERSION=1.20.3
URL=""

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
