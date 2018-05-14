#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxqt-desktop-environment
VERSION=0.11
DESCRIPTION="LXQt is a lightweight Qt desktop environment"

cd $SOURCE_DIR

#REQ:linux-pam
#REQ:shadow
#REQ:sudo
#REQ:wayland
#REQ:wayland-protocols
#REQ:xserver-meta
#REQ:openbox
#REQ:gtk2
#REQ:qt5
#REQ:libstatgrab
#REQ:polkit
#REQ:lm_sensors
#REQ:upower
#REQ:libfm
#REQ:cmake
#REQ:extra-cmake-modules
#REQ:libdbusmenu-qt
#REQ:polkit-qt
#REQ:xdg-utils
#REQ:xdg-user-dirs
#REQ:oxygen-icons5
#REQ:python-modules#pygobject3
#REQ:networkmanager
#REQ:network-manager-applet
#REQ:ModemManager
#REQ:lxqt-build-tools
#REQ:libsysstat
#REQ:libqtxdg
#REQ:lxqt-kwindowsystem
#REQ:liblxqt
#REQ:libfm-qt
#REQ:lxqt-about
#REQ:lxqt-admin
#REQ:lxqt-common
#REQ:lxqt-kwayland
#REQ:lxqt-libkscreen
#REQ:lxqt-config
#REQ:lxqt-globalkeys
#REQ:lxqt-notificationd
#REQ:lxqt-policykit
#REQ:lxqt-kidletime
#REQ:lxqt-solid
#REQ:lxqt-powermanagement
#REQ:lxqt-qtplugin
#REQ:lxqt-session
#REQ:lxqt-kguiaddons
#REQ:lxqt-panel
#REQ:lxqt-runner
#REQ:pcmanfm-qt
#REQ:lximage-qt
#REQ:obconf-qt
#REQ:pavucontrol-qt
#REQ:qtermwidget
#REQ:qterminal
#REQ:qscintilla
#REQ:juffed
#REQ:arc-gtk-theme
#REQ:numix-icons
#REQ:aryalinux-wallpapers
#REQ:aryalinux-fonts
#REQ:lightdm
#REQ:lightdm-gtk-greeter

export LXQT_PREFIX="/opt/lxqt"

sudo ln -svfn $LXQT_PREFIX/share/lxqt /usr/share/lxqt &&

sudo cp -v {$LXQT_PREFIX,/usr}/share/xsessions/lxqt.desktop &&

for i in $LXQT_PREFIX/share/applications/*
do
  sudo ln -svf $i /usr/share/applications/
done

for i in $LXQT_PREFIX/share/desktop-directories/*
do
  sudo ln -svf $i /usr/share/desktop-directories/
done

unset i

sudo ldconfig

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
