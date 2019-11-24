#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:accountsservice
#REQ:desktop-file-utils
#REQ:gcr
#REQ:gsettings-desktop-schemas
#REQ:libsecret
#REQ:rest
#REQ:totem-pl-parser
#REQ:vte
#REQ:yelp-xsl
#REQ:gconf
#REQ:geocode-glib
#REQ:gjs
#REQ:gnome-desktop
#REQ:gnome-menus
#REQ:libnotify
#REQ:gnome-online-accounts
#REQ:gnome-video-effects
#REQ:grilo
#REQ:libchamplain
#REQ:libgdata
#REQ:libgee
#REQ:libgtop
#REQ:libgweather
#REQ:libpeas
#REQ:libwacom
#REQ:libwnck
#REQ:evolution-data-server
#REQ:folks
#REQ:gfbgraph
#REQ:telepathy-glib
#REQ:telepathy-logger
#REQ:telepathy-mission-control
#REQ:caribou
#REQ:dconf
#REQ:gnome-backgrounds
#REQ:librsvg
#REQ:gnome-themes-extra
#REQ:gvfs
#REQ:nautilus
#REQ:zenity
#REQ:gnome-bluetooth
#REQ:gnome-keyring
#REQ:clutter-gst
#REQ:cups
#REQ:cups-filters
#REQ:gnome-settings-daemon
#REQ:grilo
#REQ:gnome-control-center
#REQ:mutter
#REQ:gnome-shell
#REQ:gnome-shell-extensions
#REQ:dash-to-panel
#REQ:dash-to-dock
#REQ:gnome-session
#REQ:lightdm-gtk-greeter
#REQ:gnome-user-docs
#REQ:baobab
#REQ:brasero
#REQ:cheese
#REQ:eog
#REQ:evince
#REQ:file-roller
#REQ:gedit
#REQ:gtksourceview4
#REQ:gnome-calculator
#REQ:gnome-disk-utility
#REQ:gnome-logs
#REQ:gnome-maps
#REQ:gnome-nettool
#REQ:gnome-power-manager
#REQ:gnome-system-monitor
#REQ:gnome-terminal
#REQ:gnome-weather
#REQ:gucharmap
#REQ:vino
#REQ:vinagre
#REQ:network-manager-applet
#REQ:seahorse
#REQ:notification-daemon
#REQ:polkit-gnome
#REQ:xdg-user-dirs
#REQ:gnome-tweaks
#REQ:pavucontrol
#REQ:aryalinux-wallpapers
#REQ:aryalinux-google-fonts
#REQ:aryalinux-icons
#REQ:aryalinux-gtk-themes
#REQ:aryalinux-gnome-settings
#REQ:plymouth


cd $SOURCE_DIR



NAME=gnome-desktop-environment
VERSION=3.32.0


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

sudo sed -i 's@MimeType=inode/directory@# MimeType=inode/directory@g' /usr/share/applications/org.gnome.baobab.desktop
sudo update-desktop-database
sudo update-mime-database /usr/share/mime
pushd $SOURCE_DIR
wget https://raw.githubusercontent.com/FluidIdeas/utils/master/wallpaper-list-update.sh
sudo chmod a+x wallpaper-list-update.sh
sudo ./wallpaper-list-update.sh
sudo rm wallpaper-list-update.sh
popd
sudo tee /etc/profile.d/aryalinux-desktop.sh << EOF
cd ~
xdg-user-dirs-update
default-gnome-user-instructions
EOF
sudo rm -rvf /usr/share/xsessions/gnome.desktop


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

