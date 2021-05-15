#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gconf
#REQ:gtk2
#REQ:gtk3
#REQ:frameworks5
#REQ:libpwquality
#REQ:libxkbcommon
#REQ:mesa
#REQ:wayland
#REQ:networkmanager
#REQ:pipewire
#REQ:pulseaudio
#REQ:qca
#REQ:sassc
#REQ:taglib
#REQ:xcb-util-cursor
#REQ:fftw
#REQ:gsettings-desktop-schemas
#REQ:libdbusmenu-qt
#REQ:libcanberra
#REQ:libinput
#REQ:linux-pam
#REQ:lm_sensors
#REQ:oxygen-icons5
#REQ:pciutils
#REQ:smartmontools


cd $SOURCE_DIR



NAME=plasma-all
VERSION=5.21.5
SECTION="KDE Plasma 5"


cd $SOURCE_DIR

packages="
kdecoration
libkscreen
libksysguard
breeze
breeze-gtk
kscreenlocker
oxygen
kinfocenter
ksysguard
kwayland-server
kwin
plasma-workspace
plasma-disks
bluedevil
kde-gtk-config
khotkeys
kmenuedit
kscreen
kwallet-pam
kwayland-integration
kwrited
milou
plasma-nm
plasma-pa
plasma-workspace-wallpapers
polkit-kde-agent-1
powerdevil
plasma-desktop
kdeplasma-addons
kgamma5
ksshaskpass
sddm-kcm
discover
kactivitymanagerd
plasma-integration
plasma-tests
xdg-desktop-portal-kde
drkonqi
plasma-vault
plasma-browser-integration
kde-cli-tools
systemsettings
plasma-thunderbolt
plasma-firewall
plasma-systemmonitor
qqc2-breeze-style
"

base_url = "https://download.kde.org/stable/plasma/$VERSION/"

for pkg in $(echo $packages); do
    if ! grep pkg /tmp/framework-pkgs &> /dev/null; then
        wget "$base_url$pkg"
        tarball=$(echo "$base_url$pkg" | rev | cut -d/ -f1 | rev)
        directory=$(tar tf $tarball)

        tar xf $tarball
        pushd $directory
            mkdir build
            cd build
            cmake -DCMAKE_INSTALL_PREFIX=/usr      \
                -DCMAKE_BUILD_TYPE=Release         \
                -DBUILD_TESTING=OFF                \
                -Wno-dev ..
            make
            sudo make install
        popd
        rm -rf $directory
        echo $pkg | tee -a /tmp/framework-pkgs
    fi
done

sudo tee /etc/pam.d/kde << "EOF"
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF

sudo tee /etc/pam.d/kde-np << "EOF"
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF

sudo tee /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF


register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
