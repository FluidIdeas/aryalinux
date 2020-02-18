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
VERSION=5.18.0

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


url=http://download.kde.org/stable/plasma/5.18.0/
cat > plasma-5.18.0.md5 << "EOF"
65ad6be44bae48a8b95282f38a172bd5  kdecoration-5.18.0.tar.xz
352ee02e39de0bb991fde185d910dc2b  libkscreen-5.18.0.tar.xz
6cd8353bb8ee8017eb9cec1d9784354e  libksysguard-5.18.0.tar.xz
4bfa3626154af80e53fa6df31088fa5d  breeze-5.18.0.tar.xz
6f4e972f00edbcc3078646066546fd1d  breeze-gtk-5.18.0.tar.xz
44ced6d2ea583ecdf39eb12121f797ea  kscreenlocker-5.18.0.tar.xz
8ad9334b3b7cdc74a457a43fe8e3d763  oxygen-5.18.0.tar.xz
49a00ae8e8516ee9c63b1361e7e8b35a  kinfocenter-5.18.0.tar.xz
8877136028cbf810156ace05e23a0606  ksysguard-5.18.0.tar.xz
6c9e520619c2dd1cfb58b18c39a35a2a  kwin-5.18.0.tar.xz
37a8c7b47c30a6fbc96812e07e520a17  plasma-workspace-5.18.0.tar.xz
2df5eab9f574037d8ddd44595ae9740b  bluedevil-5.18.0.tar.xz
0bdcc24e5892f1ef18dacec5a7a02335  kde-gtk-config-5.18.0.tar.xz
c9aa2a00ef44caf72fc35bac425bfb11  khotkeys-5.18.0.tar.xz
bf513fd5cb621fe6188ae539af1357a0  kmenuedit-5.18.0.tar.xz
a24eb028b1942bbb6be277830c883ca4  kscreen-5.18.0.tar.xz
ff159637ce8450930120560657dc7aa4  kwallet-pam-5.18.0.tar.xz
76828427796d566b04947c01219fb538  kwayland-integration-5.18.0.tar.xz
26a01a5e99685854aa6cee4c1b5aa3ac  kwrited-5.18.0.tar.xz
75d8aef7a58acabd6cbf8e58622264e2  milou-5.18.0.tar.xz
3702c99b031856ee14facf953ab96a12  plasma-nm-5.18.0.tar.xz
af558e3b675c1dbde752b8f27d107f34  plasma-pa-5.18.0.tar.xz
dbbf224c5f626d6e93aa049f05c79824  plasma-workspace-wallpapers-5.18.0.tar.xz
64d690559f2ae9ad9724709d880e500b  polkit-kde-agent-1-5.18.0.tar.xz
2a295e35d8344c8c486d35ce31daed2e  powerdevil-5.18.0.tar.xz
f7763083a9ae5562a88725ede46019d9  plasma-desktop-5.18.0.tar.xz
fbd61128d753723f94f3e3377f1c6dbf  kdeplasma-addons-5.18.0.tar.xz
04ff88998c5a0732b9a1bb76320155ca  kgamma5-5.18.0.tar.xz
54420fb7d114b527c820018db615db80  ksshaskpass-5.18.0.tar.xz
#246b73de780bf92444ac4d6f69f50d2f  plasma-sdk-5.18.0.tar.xz
3ae3cbec00e5f354e680ae88683e92b4  sddm-kcm-5.18.0.tar.xz
01663f7d1817c976119189ccbd8fc139  user-manager-5.18.0.tar.xz
434034a0af6aa4456adef6002f9964d7  discover-5.18.0.tar.xz
#0a5db8616c37961c34b4107672f8ca1f  breeze-grub-5.18.0.tar.xz
#2483b77974bfcd0b311d10d947486b8d  breeze-plymouth-5.18.0.tar.xz
19eeb2603042ed8f13861728a42240c3  kactivitymanagerd-5.18.0.tar.xz
75ba0f7a3eb652b8aa52cdb2bb6cf449  plasma-integration-5.18.0.tar.xz
71b682f963f4c219a10c92706f7e0de0  plasma-tests-5.18.0.tar.xz
#2d10a553fa7d7ab7df3ad14ce41d4f7e  plymouth-kcm-5.18.0.tar.xz
6801ac281d11cd0b06132b8f0044b913  xdg-desktop-portal-kde-5.18.0.tar.xz
69c20946b2cfaa5d94443bf2daa5cefc  drkonqi-5.18.0.tar.xz
404bb032a9870e2182ed28bac4b62f30  plasma-vault-5.18.0.tar.xz
916bb56baee7ce272dc0076eef96c116  plasma-browser-integration-5.18.0.tar.xz
6d28a752327246b0085192d784a30164  kde-cli-tools-5.18.0.tar.xz
b89a6fcfd152fcff0c737b7994b93503  systemsettings-5.18.0.tar.xz
9a4d8193ff7a01e0fea74de69897f63a  plasma-thunderbolt-5.18.0.tar.xz
#7f67365c7aa0e385abdc3b8e5a4ed290  plasma-nano-5.18.0.tar.xz
#98a08ead926817ef803e0f0037ed7336  plasma-phone-components-5.18.0.tar.xz
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

done < plasma-5.18.0.md5

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

