#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="xfce-desktop-environment"
DESCRIPTION="A popular lightweight gtk based desktop environment"
VERSION=4.12

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info

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
#REQ:mousepad
#REQ:vte2
#REQ:xfce4-terminal
#REQ:xfburn
#REQ:ristretto
#REQ:xfce4-notifyd
#REQ:pnmixer
#REQ:xfce4-whiskermenu-plugin
#REQ:xfce4-screenshooter
#REQ:p7zip-full
#REQ:xarchiver
#REQ:imagemagick
#REQ:thunar-archive-plugin
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:galculator
#REQ:epdfview

#REQ:gcr
#REQ:gvfs
#REQ:polkit-gnome

#REQ:plymouth
#REQ:lightdm
#REQ:lightdm-gtk-greeter

#REQ:murrine-gtk-engine
#REQ:adwaita-icon-theme

#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton

#REQ:arc-gtk-theme
#REQ:breeze-gtk-theme
#REQ:greybird-gtk-theme
#REQ:numix-icons

cd $SOURCE_DIR
wget -nc http://aryalinux.com/files/binaries/aryalinux-xfce-config.tar.gz
sudo tar xf aryalinux-xfce-config.tar.gz -C /etc/skel
sudo cp -rf /etc/skel/.config ~
sudo cp -rf /etc/skel/.bash* ~
sudo chown -R $USER:$USER ~/.config
sudo chown -R $USER:$USER ~/.bash*
xdg-user-dirs-update --force

sudo tee /etc/gtk-2.0/gtkrc <<"EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF

sudo mkdir -pv /etc/polkit-1/localauthority/50-local.d/
sudo mkdir -pv /etc/polkit-1/rules.d/

sudo tee /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManagerAndUdisks2.rules <<"EOF"
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 || action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0) {
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

if [ ! -f /usr/share/pixmaps/aryalinux.png ]
then
cd $SOURCE_DIR
wget -nc http://aryalinux.com/files/aryalinux.png
pushd /usr/share/pixmaps/
sudo cp -v $SOURCE_DIR/aryalinux.png .
popd
fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
