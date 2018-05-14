#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME=kde-desktop-environment
DESCRIPTION="The KDE 5 Plasma Desktop environment"
VERSION=5.9.1

#REQ:gtk2
#REQ:gtk3
#REQ:GConf
#REQ:pulseaudio
#REQ:qt5
#REQ:extra-cmake-modules
#REQ:phonon
#REQ:phonon-backend-gstreamer
#REQ:polkit-qt
#REQ:libdbusmenu-qt
#REQ:oxygen-fonts
#REQ:noto-fonts
#REQ:kframeworks5
#REQ:ark5
#REQ:kate5
#REQ:kdenlive
#REQ:kmix5
#REQ:khelpcenter
#REQ:konsole5
#REQ:libkexiv2
#REQ:okular5
#REQ:libkdcraw
#REQ:gwenview5
#REQ:plasma-all
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:lightdm
#REQ:lightdm-gtk-greeter

sudo mkdir -pv /usr/share/xsessions/
sudo cp -v /opt/kf5/share/xsessions/* /usr/share/xsessions/

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
pushd /var/cache/alps/sources &&
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux.png
sudo cp aryalinux.png /usr/share/pixmaps/
popd
fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
