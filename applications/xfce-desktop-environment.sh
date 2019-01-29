#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libxfce4util
#REQ:xfconf
#REQ:libxfce4ui
#REQ:exo
#REQ:garcon
#REQ:gtk-xfce-engine
#REQ:libwnck2
#REQ:xfce4-panel
#REQ:xfce4-xkb-plugin
#REQ:thunar
#REQ:thunar-volman
#REQ:tumbler
#REQ:xfce4-appfinder
#REQ:xfce4-power-manager
#REQ:xfce4-settings
#REQ:xfdesktop
#REQ:xfwm4
#REQ:xfce4-session
#REQ:parole
#REQ:xfce4-terminal
#REQ:xfburn
#REQ:ristretto
#REQ:xfce4-notifyd
#REQ:aryalinux-gtk-themes
#REQ:aryalinux-google-fonts
#REQ:aryalinux-wallpapers
#REQ:aryalinux-icons
#REQ:lightdm

cd $SOURCE_DIR


NAME=xfce-desktop-environment
VERSION=4.12
URL=""

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
