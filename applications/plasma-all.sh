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
VERSION=5.16.4


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


url=http://download.kde.org/stable/plasma/5.16.4/
wget -r -nH -nd -np -A '*.xz' $url
cat > plasma-5.16.4.md5 << "EOF"
5e44ce8c340a2776d0c26c01e052de98  kdecoration-5.16.4.tar.xz
e9a04fac01548ed807f1e74afa6cecbc  libkscreen-5.16.4.tar.xz
54f83ba22b7bffb8b29ecb4304eba290  libksysguard-5.16.4.tar.xz
b9669c56c282a3a99ad8b5c8ab9e28e7  breeze-5.16.4.tar.xz
6800789a7165d7d0ea5cab3f37a412d8  breeze-gtk-5.16.4.tar.xz
68d3ce5b520f3295cdf449d129163f31  kscreenlocker-5.16.4.tar.xz
37b8aa51e815547a0ca7891f6f28bfd1  oxygen-5.16.4.tar.xz
f0aca5810cbf7d6fe9b234dd188bf866  kinfocenter-5.16.4.tar.xz
42ad987f068e263e2c04bd46203748aa  ksysguard-5.16.4.tar.xz
03e03a0d82a2c7a44357a0b70a818364  kwin-5.16.4.tar.xz
28ecbe477db45e0ec87d04d89cd00a5e  plasma-workspace-5.16.4.tar.xz
2f5c188ec483ba13a141d01f914fbdca  bluedevil-5.16.4.tar.xz
d57f164978aa8ddaa2029834197cd79c  kde-gtk-config-5.16.4.tar.xz
d665005eee4c4f286d02352f3ed1cca8  khotkeys-5.16.4.tar.xz
8411a6adb83f6d07ce57d68518524a60  kmenuedit-5.16.4.tar.xz
3e8620ef18c1a077da5b94d2d8da221f  kscreen-5.16.4.tar.xz
578af3befcb637107e38ef68904549b1  kwallet-pam-5.16.4.tar.xz
95e8f7c97d92ce842f4cd88e4244164f  kwayland-integration-5.16.4.tar.xz
0193b8e80dcdff29b9bde53bfcbe57e7  kwrited-5.16.4.tar.xz
40f100f10fc791b636c90a890d6a72d0  milou-5.16.4.tar.xz
fdfc54509ba708cc341a0e0b5925c04c  plasma-nm-5.16.4.tar.xz
243d1a5f17ea39cae8df5051a4d57a74  plasma-pa-5.16.4.tar.xz
1c6dcff4dd988d57e8666d29436cd770  plasma-workspace-wallpapers-5.16.4.tar.xz
251a7f86e34c718c76b5463ff923f1f4  polkit-kde-agent-1-5.16.4.tar.xz
d7d1e680ebb4bd522e09cd3d7c485809  powerdevil-5.16.4.tar.xz
9f6022331ff678064507f8c1936db3b6  plasma-desktop-5.16.4.tar.xz
66cf356c39e8e5a361fa5bdbac07ea0e  kdeplasma-addons-5.16.4.tar.xz
a4bbf8ecc177bb640a21e0b699f41717  kgamma5-5.16.4.tar.xz
f4cdc68f40a0d9de75080473c5653aeb  ksshaskpass-5.16.4.tar.xz
#98189f9c245ee94c36b52c0b4899fd6a  plasma-sdk-5.16.4.tar.xz
0614d7063840aa22c5f273aa94eb59b5  sddm-kcm-5.16.4.tar.xz
87770cae80be1d91f5a69e6964b35d90  user-manager-5.16.4.tar.xz
31de7a8ab5233c568331c415a9932afb  discover-5.16.4.tar.xz
#9cd0a7f9624a2f2b4b0fa56913644431  breeze-grub-5.16.4.tar.xz
#973aad521ffcd3f4713984ed7c30ffe2  breeze-plymouth-5.16.4.tar.xz
4fde8ca5608fd6af1612695b7d1574bc  kactivitymanagerd-5.16.4.tar.xz
31b52d29b0aa1c6be4d90844217c7e63  plasma-integration-5.16.4.tar.xz
d66af09fc97717ca4da55e37646708c5  plasma-tests-5.16.4.tar.xz
3544c8e414e44c1a4622fa706dc09e93  plymouth-kcm-5.16.4.tar.xz
3877c03570407e2382899b76e36e71cf  xdg-desktop-portal-kde-5.16.4.tar.xz
8a5a274541943f365aa971318b52dc33  drkonqi-5.16.4.tar.xz
2c323e7f60b6042d0b8c66f0726e7499  plasma-vault-5.16.4.tar.xz
b48e4ea395f4ca9a98aecb4cb9616186  plasma-browser-integration-5.16.4.tar.xz
5c1a41d205f55cc7828c485d08a366f3  kde-cli-tools-5.16.4.tar.xz
39f47836ddf69aed04a26e26899a208a  systemsettings-5.16.4.tar.xz
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

done < plasma-5.16.4.md5

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

