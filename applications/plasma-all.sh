#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gconf
#REQ:gtk2
#REQ:gtk3
#REQ:krameworks5
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


cd $SOURCE_DIR



NAME=plasma-all
VERSION=5.17.3


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

echo $USER > /tmp/currentuser


url=http://download.kde.org/stable/plasma/5.17.3/
wget -r -nH -nd -np -A '*.xz' $url
cat > plasma-5.17.3.md5 << "EOF"
57d33092638b1671546f5aa58f62939a  kdecoration-5.17.3.tar.xz
131d445c156a425e4fd16a2c6e16e8f2  libkscreen-5.17.3.tar.xz
8e287b24d6697ae7e75824ddaa0c2409  libksysguard-5.17.3.tar.xz
fde85cab245f8337767663430c4c48b0  breeze-5.17.3.tar.xz
d859abc935e4bae7c8556a7d0823c11c  breeze-gtk-5.17.3.tar.xz
f7201f181c9fa8080205a571efd1ae1a  kscreenlocker-5.17.3.tar.xz
ebb0a647b32cfc99db0fd41c418ee007  oxygen-5.17.3.tar.xz
41fb0b9800fee5710c401836b9ce5a04  kinfocenter-5.17.3.tar.xz
251ed74fff7b7bca46c4af973554bd1a  ksysguard-5.17.3.tar.xz
a32ce47f33af05ddd29d55be9b4fab7c  kwin-5.17.3.tar.xz
90a8576c6d95d0e6f74213df041f1df1  plasma-workspace-5.17.3.tar.xz
ccd075deae5d603a78479f2fe64a6811  bluedevil-5.17.3.tar.xz
937824ad2d27d49c31a6b302dbf016ba  kde-gtk-config-5.17.3.tar.xz
95027338f2c05183f3d4e51b5472dd6e  khotkeys-5.17.3.tar.xz
01004da1aad8cd6f927516ba320fcd49  kmenuedit-5.17.3.tar.xz
af1d6e15b12d2c6675037ea91650eb48  kscreen-5.17.3.tar.xz
61c93e0714314bc5c9b9313d68eb979c  kwallet-pam-5.17.3.tar.xz
f884e200e14299031f2948215cecf20d  kwayland-integration-5.17.3.tar.xz
fd7a1ebb83b4318fa6475782011d4066  kwrited-5.17.3.tar.xz
0a43963ab03fbac7472eb28dd897e627  milou-5.17.3.tar.xz
ad793139e22ecdfddb55897f7e1d9c59  plasma-nm-5.17.3.tar.xz
d97f0f8d87bf6113cc642b06ca254dfd  plasma-pa-5.17.3.tar.xz
b7e1a3b3bcc10156eadb66114827f2cb  plasma-workspace-wallpapers-5.17.3.tar.xz
9d8f7f5dd2ac879ebdda237208698210  polkit-kde-agent-1-5.17.3.tar.xz
9738628a1dc638abedcceb62f9ec18e4  powerdevil-5.17.3.tar.xz
bc459ace55e8700c83d4e41d9460965e  plasma-desktop-5.17.3.tar.xz
525de501b3f4f4bd3794229c31db56be  kdeplasma-addons-5.17.3.tar.xz
c967101a7f7fb0aa9a3326852a39be1f  kgamma5-5.17.3.tar.xz
6dde0208679753dfbae2ca32c14a03a7  ksshaskpass-5.17.3.tar.xz
#13194ee111514f7806eae32385e343c2  plasma-sdk-5.17.3.tar.xz
b8f0915909f52fffa0122d0500c3b577  sddm-kcm-5.17.3.tar.xz
4eade66f63f4cae1a6873543eebdca64  user-manager-5.17.3.tar.xz
eae7d894d0093610eadac232a7b2bf22  discover-5.17.3.tar.xz
#ab24a2b93148403f27ee2684d8a91bb7  breeze-grub-5.17.3.tar.xz
#7d99290a4168b0299b7ccd1ae450adca  breeze-plymouth-5.17.3.tar.xz
00b3dbeeb2002c5001cc80b0e23632ba  kactivitymanagerd-5.17.3.tar.xz
1268e0848969b20892e6e38d2299a774  plasma-integration-5.17.3.tar.xz
3ec80d38a08d86a417c0cedeab1309d3  plasma-tests-5.17.3.tar.xz
#868c68f45337ae8a66a488d2f596cf01  plymouth-kcm-5.17.3.tar.xz
7a5bc2995863afd2fa3629edc3fbdc74  xdg-desktop-portal-kde-5.17.3.tar.xz
fb7add39aef8dbb15e4b4cfb6dccae20  drkonqi-5.17.3.tar.xz
03d4d20efeb96a2c2ec5e6b1d5e856e1  plasma-vault-5.17.3.tar.xz
10181267dba716be0b79e238f6e741ef  plasma-browser-integration-5.17.3.tar.xz
aa7f2afc78ddd303b550631c3fdcc907  kde-cli-tools-5.17.3.tar.xz
459b1c66617e441f5002cad71a5d5b77  systemsettings-5.17.3.tar.xz
d85c6f197c7f13557819b91bd20fa99f  plasma-thunderbolt-5.17.3.tar.xz
EOF
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    tar -xf $file
    pushd $packagedir

       # Fix some build issues when generating some configuration files
       case $name in
         plasma-workspace)
           sed -i '/set.HAVE_X11/a set(X11_FOUND 1)' CMakeLists.txt
         ;;
      
         khotkeys)
           sed -i '/X11Extras/a set(X11_FOUND 1)' CMakeLists.txt
         ;;
      
         plasma-desktop)
           sed -i '/X11.h)/i set(X11_FOUND 1)' CMakeLists.txt
         ;;
       esac

       mkdir build
       cd    build

       cmake -DCMAKE_INSTALL_PREFIX=/usr \
             -DCMAKE_BUILD_TYPE=Release         \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&

        make
        as_root make install
    popd


    as_root rm -rf $packagedir
    as_root /sbin/ldconfig

done < plasma-5.17.3.md5

exit
as_root install -dvm 755 /usr/share/xsessions              &&
cd /usr/share/xsessions/                                   &&
[ -e plasma.desktop ]                                      ||
as_root ln -sfv /usr/share/xsessions/plasma.desktop &&
as_root install -dvm 755 /usr/share/wayland-sessions       &&
cd /usr/share/wayland-sessions/                            &&
[ -e plasma.desktop ]                                      ||
as_root ln -sfv /usr/share/wayland-sessions/plasma.desktop
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/pam.d/kde << "EOF" 
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

cat > /etc/pam.d/kde-np << "EOF" 
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

cat > /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed '/^Name=/s/Plasma/Plasma on Xorg/' -i /usr/share/xsessions/plasma.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

