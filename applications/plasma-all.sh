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
VERSION=5.18.1

SECTION="KDE Plasma 5"

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


url=http://download.kde.org/stable/plasma/5.18.1/
cat > plasma-5.18.1.md5 << "EOF"
be7cccb3859c253740ad20eae56a1457  kdecoration-5.18.1.tar.xz
84b92ff5c7ab70537bc757122375ab3c  libkscreen-5.18.1.tar.xz
645e7d0e5167d89abfcb0011748179a8  libksysguard-5.18.1.tar.xz
0d6769306901883a9aadaaed4c199314  breeze-5.18.1.tar.xz
9c797eddc66820e119a32b3ca0e54327  breeze-gtk-5.18.1.tar.xz
2369c961fee61992bf16f8e5aabc296a  kscreenlocker-5.18.1.tar.xz
da5b0b9caca27a0b7faea3aac732e5d5  oxygen-5.18.1.tar.xz
c687fdd7a0c36a3a6d7ebd063f3aee61  kinfocenter-5.18.1.tar.xz
ae2bf8875c1b374d172267c7a0cca982  ksysguard-5.18.1.tar.xz
216b067f13f43238c7515815001fc862  kwin-5.18.1.tar.xz
97c106ec13bd9ecf87cc61e1cc29f374  plasma-workspace-5.18.1.tar.xz
8d3ea52e9b215523225e316d47469f3f  bluedevil-5.18.1.tar.xz
7c16855fe0c390a9eaa60d2f4e624736  kde-gtk-config-5.18.1.tar.xz
597ac5c22e2dc7bad5773781c4f5c563  khotkeys-5.18.1.tar.xz
cd59deb1769ed3fdcfd620f1d5e82676  kmenuedit-5.18.1.tar.xz
e957ca2f6374385e3b5598f839f843a5  kscreen-5.18.1.tar.xz
25db35f344bd12fdf6d6e54b87d4b90c  kwallet-pam-5.18.1.tar.xz
8bda1526aa7f9dbf6aa842b08cf22655  kwayland-integration-5.18.1.tar.xz
d0a29aed4ee8bcd9fce3e545f82832be  kwrited-5.18.1.tar.xz
2f4252bc1a8b07062e57d229fc3bc361  milou-5.18.1.tar.xz
8663fa971594bc70d6898e8604f8c99a  plasma-nm-5.18.1.tar.xz
0554888991a1f1f70cbbb95afa48184a  plasma-pa-5.18.1.tar.xz
25fcaf7cb52f20b3126af9baa1409e3c  plasma-workspace-wallpapers-5.18.1.tar.xz
0b88def5b87e822aa7370d91dfd07913  polkit-kde-agent-1-5.18.1.tar.xz
0326bf85fb50e15d5e78c43be9457993  powerdevil-5.18.1.tar.xz
58ec01d70d18f23a03ec2040beb506f1  plasma-desktop-5.18.1.tar.xz
9a44fb928f5dd22a695d38617660aeee  kdeplasma-addons-5.18.1.tar.xz
7200c6ebdc63dde79f64a9b2472b2d37  kgamma5-5.18.1.tar.xz
78d68fd989b451a8e75fd9278a0c1947  ksshaskpass-5.18.1.tar.xz
#4c907670bbe788499038254311f6ac0b  plasma-sdk-5.18.1.tar.xz
7533a7a459d476ece00d558d4fc9a8f7  sddm-kcm-5.18.1.tar.xz
2b2351beb674ce01cca0b58d3c8a49b2  user-manager-5.18.1.tar.xz
c76653dce9c3f9f1ac1edae6fe342ee7  discover-5.18.1.tar.xz
#ca25ee8ad60b64d19850ccba8994547c  breeze-grub-5.18.1.tar.xz
#c8377f0f2ac3109014c8062e74145def  breeze-plymouth-5.18.1.tar.xz
7b5e6cbb5d84b69745030773bea176c0  kactivitymanagerd-5.18.1.tar.xz
fa2e316a15f24c64a71c36d30b7f7585  plasma-integration-5.18.1.tar.xz
a5d8cc4a47ba59969f98be0cc5800f83  plasma-tests-5.18.1.tar.xz
#c13ae6eaa29760e67a9c17d6a1a48153  plymouth-kcm-5.18.1.tar.xz
d6e2d1a982c83a553607d46a04fcfff7  xdg-desktop-portal-kde-5.18.1.tar.xz
5b7bf736b767d40d77a4c51bca9708e0  drkonqi-5.18.1.tar.xz
1ccf74eb8b851b1dba87f2cd3ed54052  plasma-vault-5.18.1.tar.xz
a0f85c77e48c35a17cc326491155249e  plasma-browser-integration-5.18.1.tar.xz
7d73463b9115234991a631dc6741bab4  kde-cli-tools-5.18.1.tar.xz
d420ca0680c67496b8572b143aae1dc9  systemsettings-5.18.1.tar.xz
a2ae6b65f5ae2df57cfb29bf8ae56eda  plasma-thunderbolt-5.18.1.tar.xz
#3df1a7d13f5cce484ce8fb684c1c0015  plasma-nano-5.18.1.tar.xz
#498e4c99016d51bc44abdb8416e7dba2  plasma-phone-components-5.18.1.tar.xz
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
    touch /tmp/plasma-done
    if grep $file /tmp/plasma-done; then continue; fi
    wget -nc $url/$file
    if echo $file | grep /; then file=$(echo $file | cut -d/ -f2); fi

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
echo $file >> /tmp/plasma-done

done < plasma-5.18.1.md5

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

