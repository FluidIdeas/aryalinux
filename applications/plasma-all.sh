#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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
#REQ:x7driver#libinput
#REQ:linux-pam
#REQ:lm_sensors
#REQ:oxygen-icons5
#REQ:pciutils


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/plasma/5.15.5


NAME=plasma-all
VERSION=5.15.5
URL=http://download.kde.org/stable/plasma/5.15.5

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


url=http://download.kde.org/stable/plasma/5.15.5/
wget -r -nH -nd -A '*.xz' -np $url
cat > plasma-5.15.5.md5 << "EOF"
12e66b250e0e0036e837648f72e94b4e  kdecoration-5.15.5.tar.xz
08e28135014852c1bf57dd738a7c8cda  libkscreen-5.15.5.tar.xz
3fa13483c9f888571fa1a8a7a1ef821e  libksysguard-5.15.5.tar.xz
52221a5e47ffca0cffdc4577e9b097e2  breeze-5.15.5.tar.xz
5aea654d15d6c107141affa6e32d1d4d  breeze-gtk-5.15.5.tar.xz
be96a0ab64cbeb9b9f728a977c0e2e6b  kscreenlocker-5.15.5.tar.xz
f561b58231384cf96e62768c7ebe4611  oxygen-5.15.5.tar.xz
746b45e6d987b25a44e4469c7f66982f  kinfocenter-5.15.5.tar.xz
8f86ba0db6971a7a331b0314971fa6ae  ksysguard-5.15.5.tar.xz
91401cff50e97b2f153080e1a9d295d0  kwin-5.15.5.tar.xz
a8598e9d6504f08389e5b0cdceae468c  plasma-workspace-5.15.5.tar.xz
f5cacbe4bfc12ca36535711d0562122f  bluedevil-5.15.5.tar.xz
5790d8f3be565c9f78a1a3dbe77dafe6  kde-gtk-config-5.15.5.tar.xz
e40ad49f14cfe51e35c94e46bf4dcfb6  khotkeys-5.15.5.tar.xz
38316c5655e273a2e5ee4bd096cee1a7  kmenuedit-5.15.5.tar.xz
6ab623e477248aa4faf2bbf157fc786b  kscreen-5.15.5.tar.xz
4f563fc433dfd43960832fb7ddac6137  kwallet-pam-5.15.5.tar.xz
4c029d5a2e0dec0c9ca746d910393ae3  kwayland-integration-5.15.5.tar.xz
841b5be4dec688ac30c32f30045f96b5  kwrited-5.15.5.tar.xz
ae3357fdfdfbf8c996b9ea5c445f042d  milou-5.15.5.tar.xz
806534c2fd234aa8630c5bfc6b4b8b54  plasma-nm-5.15.5.tar.xz
599c5fcee476afb5cd59e6961c8c525f  plasma-pa-5.15.5.tar.xz
293d855ff8df007a1c75b2a4b0a29c47  plasma-workspace-wallpapers-5.15.5.tar.xz
2c0581a3b6bb66d34de3f3b185471939  polkit-kde-agent-1-5.15.5.tar.xz
08dca676733ed110ad73015ef61dfc52  powerdevil-5.15.5.tar.xz
84cea7d6cc3d014839ec7f8b9696b8f2  plasma-desktop-5.15.5.tar.xz
a194936a5fc7101d95bd92c43b377735  kdeplasma-addons-5.15.5.tar.xz
b8d639e55d1c9de2bd77d5ea234f81f5  kgamma5-5.15.5.tar.xz
965cd4f87a9bf64a7a54d511856084dd  ksshaskpass-5.15.5.tar.xz
#c14166ae4bbd60ce47d33f67c6d1718a  plasma-sdk-5.15.5.tar.xz
ebc9becccf08be045caf8c6ca86bf2fd  sddm-kcm-5.15.5.tar.xz
8e38b26a97b2b2e57b0be29d78fbb71e  user-manager-5.15.5.tar.xz
c84cfab3218989b8eae04f1414ee6cfc  discover-5.15.5.tar.xz
#c54c8792cf6db0906553da9dcdcbf80a  breeze-grub-5.15.5.tar.xz
#48f7ff45c8f976d3fe43d323797f7559  breeze-plymouth-5.15.5.tar.xz
b428a82901a772971bfc5bb3df3dead0  kactivitymanagerd-5.15.5.tar.xz
3c35e275cdc620e36857de4fea66501b  plasma-integration-5.15.5.tar.xz
8588f3aadbe22749e28bf92a90d49aab  plasma-tests-5.15.5.tar.xz
35c634a6e3b12b729dae73c9b7c3e0dc  plymouth-kcm-5.15.5.tar.xz
301ae8297bcc7891f26e065839f361e5  xdg-desktop-portal-kde-5.15.5.tar.xz
87c9f9cec68b02cf1e88ce0b655e6e08  drkonqi-5.15.5.tar.xz
f748d8b07dc118f6d2f392ae0c400606  plasma-vault-5.15.5.tar.xz
9c838fa4fedf73322d4c7279d575545e  plasma-browser-integration-5.15.5.tar.xz
15b29094d80848ed7f976a736fe058ac  kde-cli-tools-5.15.5.tar.xz
60099023cd0d88640a50f080f9ccc921  systemsettings-5.15.5.tar.xz
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

       # Fix some build issues when generating some configureation files
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

       cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
             -DCMAKE_BUILD_TYPE=Release         \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&

        make
        as_root make install
    popd


    as_root rm -rf $packagedir
    as_root /sbin/ldconfig

done < plasma-5.15.5.md5

exit

install -dvm 755 /usr/share/xsessions &&
cd /usr/share/xsessions/              &&
[ -e plasma.desktop ]                 ||
as_root ln -sfv $KF5_PREFIX/share/xsessions/plasma.desktop
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

