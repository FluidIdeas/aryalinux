#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="gnome-desktop-environment"
VERSION="3.28"
DESCRIPTION="GNOME is a desktop environment that is composed entirely of free and open-source software. GNOME was originally an acronym for GNU Network Object Model Environment."

#REQ:accountsservice
#REQ:desktop-file-utils
#REQ:gcr
#REQ:gsettings-desktop-schemas
#REQ:libsecret
#REQ:rest
#REQ:totem-pl-parser
#REQ:vte
#REQ:yelp-xsl
#REQ:GConf
#REQ:geocode-glib
#REQ:gjs
#REQ:gnome-desktop
#REQ:gnome-menus
#REQ:libnotify
#REQ:gnome-online-accounts
#REQ:gnome-video-effects
#REQ:grilo
#OPT:gtkhtml
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
#REQ:gnome-themes-standard
#REQ:gvfs
#REQ:nautilus
#REQ:zenity
#REQ:gnome-bluetooth
#REQ:gnome-keyring
#REQ:clutter-gst2
#REQ:cups
#REQ:cups-filters
#REQ:gnome-settings-daemon
#REQ:grilo2
#REQ:gnome-control-center
#REQ:mutter
#REQ:gnome-shell
#REQ:gnome-shell-extensions
#REQ:gnome-session
#OPT:plymouth
#REQ:gdm
#OPT:lightdm-gtk-greeter
#REQ:gnome-user-docs
#OPT:yelp
#REQ:baobab
#REQ:brasero
#REQ:cheese
#REQ:eog
#REQ:evince
#REQ:file-roller
#REQ:gedit
#REQ:gnome-calculator
#REQ:gnome-disk-utility
#REQ:gnome-logs
#REQ:gnome-maps
#REQ:gnome-nettool
#REQ:gnome-power-manager
#REQ:gnome-system-monitor
#REQ:gnome-terminal
#REQ:gnome-tweak-tool
#REQ:gnome-weather
#REQ:gucharmap
#REQ:network-manager-applet
#REQ:seahorse
#REQ:notification-daemon
#REQ:polkit-gnome
#REQ:vpn-support
#REQ:cups-filters
#REQ:xdg-user-dirs
#REQ:plank
#REQ:aryalinux-wallpapers
#REQ:aryalinux-fonts
#REQ:aryalinux-themes
#REQ:aryalinux-icons
#REQ:arc-gtk-theme
#REQ:paper-gtk-theme
#REQ:adapta-gtk-theme
#REQ:flat-remix-icon-theme
#REQ:numix-icons
#REQ:aryalinux-gnome-settings
#REQ:lightdm-gtk-greeter

pushd $SOURCE_DIR
wget https://raw.githubusercontent.com/FluidIdeas/utils/master/wallpaper-list-update.sh -O udpate-wallpapers.sh
chmod a+x udpate-wallpapers.sh
sudo ./udpate-wallpapers.sh
popd

sudo systemctl disable gdm
sudo systemctl enable lightdm

sudo rm -rf /etc/X11/xorg.conf.d/*

sudo tee /etc/X11/xorg.conf.d/99-synaptics-overrides.conf <<"EOF"
Section  "InputClass"
    Identifier  "touchpad overrides"
    # This makes this snippet apply to any device with the "synaptics" driver
    # assigned
    MatchDriver  "synaptics"

    ####################################
    ## The lines that you need to add ##
    # Enable left mouse button by tapping
    Option  "TapButton1"  "1"
    # Enable vertical scrolling
    Option  "VertEdgeScroll"  "1"
    # Enable right mouse button by tapping lower right corner
    Option "RBCornerButton" "3"
    ####################################

EndSection
EOF

sudo tee /etc/gtk-2.0/gtkrc <<"EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF

sudo mkdir -pv /etc/polkit-1/localauthority/50-local.d/
sudo mkdir -pv /etc/polkit-1/rules.d/

sudo tee /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManagerAndUdisks2.rules <<"EOF"
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 || 
action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0) {
    return polkit.Result.YES;
  }
});
EOF

sudo mkdir -pv /usr/share/icons/default/
sudo tee /usr/share/icons/default/index.theme <<"EOF"
[Icon Theme]
Inherits=Adwaita
EOF

ccache -C
sudo ccache -C
ccache -c
sudo ccache -c

rm -rf ~/.ccache
sudo rm -rf ~/.ccache
xdg-user-dirs-update
sudo xdg-user-dirs-update

sudo tee /etc/profile.d/xdg.sh << EOF
cd ~
xdg-user-dirs-update
EOF

if [ ! -f /usr/share/pixmaps/aryalinux.png ]
then
pushd /usr/share/pixmaps/
sudo wget https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux.png
popd
fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
