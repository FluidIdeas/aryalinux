#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxfce4util
#REQ:xfconf
#REQ:libxfce4ui
#REQ:exo
#REQ:garcon
#REQ:libwnck2
#REQ:xfce4-panel
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
#REQ:xfce4-dev-tools
#REQ:network-manager-applet
#REQ:cups
#REQ:cups-filters
#REQ:vpn-libs
#REQ:plymouth
#REQ:aryalinux-xfce-settings
#REQ:pnmixer
#REQ:xdg-user-dirs
#REQ:xdg-utils
#REQ:mousepad
#REQ:pavucontrol
#REQ:galculator
#REQ:epdfview
#REQ:p7zip
#REQ:xarchiver
#REQ:thunar-archive-plugin
#REQ:xfce4-whiskermenu-plugin
#REQ:xfce4-screenshooter


cd $SOURCE_DIR



NAME=xfce-desktop-environment
VERSION=4.14


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

sudo gtk-update-icon-cache /usr/share/icons/Flat-Remix
sudo gtk-update-icon-cache /usr/share/icons/Flat-Remix-Dark
sudo gtk-update-icon-cache /usr/share/icons/Flat-Remix-Light
sudo gtk-update-icon-cache /usr/share/icons/Numix
sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle
sudo gtk-update-icon-cache /usr/share/icons/Numix-Cicle-Light
sudo gtk-update-icon-cache /usr/share/icons/Numix-Light
sudo gtk-update-icon-cache /usr/share/icons/Numix-Square
sudo gtk-update-icon-cache /usr/share/icons/Paper
sudo gtk-update-icon-cache /usr/share/icons/Paper-Mono-Dark


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

