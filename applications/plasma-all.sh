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
#REQ:pulseaudio
#REQ:qca
#REQ:sassc
#REQ:taglib
#REQ:xcb-util-cursor
#REC:fftw
#REC:gsettings-desktop-schemas
#REC:libdbusmenu-qt
#REC:libcanberra
#REC:libinput
#REC:linux-pam
#REC:lm_sensors
#REC:oxygen-icons5
#REC:pciutils

cd $SOURCE_DIR


NAME=plasma-all
VERSION=5.14.4
URL=""

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

touch plasma-all.log
url=http://download.kde.org/stable/plasma/5.15.0/
wget -nc -r -nH -nd -A '*.xz' -np $url
cat > plasma-5.15.0.md5 << "EOF"
1195f11a0f135da965f7c84a0b535ad6 kdecoration-5.15.0.tar.xz
0d4896be04000503bedcf5c7d51e896a libkscreen-5.15.0.tar.xz
784f3f907050c36265d0c289aa15779f libksysguard-5.15.0.tar.xz
41d68903361098906f7feb05aeef96da breeze-5.15.0.tar.xz
9a0d85a3a6b97e0f0920604e73c8f4f8 breeze-gtk-5.15.0.tar.xz
0ed614d82dff50dd7b1df7165113f600 kscreenlocker-5.15.0.tar.xz
86528bd2bd6f8a66108fc2ceba3cc1af oxygen-5.15.0.tar.xz
fdd8a90fc4b917602547adf44553990d kinfocenter-5.15.0.tar.xz
8c0b0aaf98727d52c00bfe3ca5152775 ksysguard-5.15.0.tar.xz
52f86eb52dda1ccd547a8a66893d439e kwin-5.15.0.tar.xz
5424d6b8af2025c44acdaea10615a539 plasma-workspace-5.15.0.tar.xz
8649b958165f1a87f07373be0f97fbf3 bluedevil-5.15.0.tar.xz
2914de589f74b154fe29e3103be34ef6 kde-gtk-config-5.15.0.tar.xz
79d22683db231b7623cf2ebe384994b6 khotkeys-5.15.0.tar.xz
821abe928b627a33ae43ffeace3990e5 kmenuedit-5.15.0.tar.xz
60dae1dde512a5b8c8f54adb48e83ec4 kscreen-5.15.0.tar.xz
2c41b3ae8862a4243169e45348b1cd63 kwallet-pam-5.15.0.tar.xz
ef01bd635719a4bf3c6845dbc08e7bc3 kwayland-integration-5.15.0.tar.xz
6d461e4deeeae854e7efdff26c0fbc2e kwrited-5.15.0.tar.xz
7fd8557369f2d3a59e1d84c78a265afc milou-5.15.0.tar.xz
d3c9475c2b51cdb1f2efedfb5ab6cf88 plasma-nm-5.15.0.tar.xz
6eab227685df4ccd68ada3a4b633711f plasma-pa-5.15.0.tar.xz
93a379e907d3b03205771e1b5c20ea7d plasma-workspace-wallpapers-5.15.0.tar.xz
ed5c4fc72e5d72c8da607bd5fe60693f polkit-kde-agent-1-5.15.0.tar.xz
12d65231a8265ee56d2ef1915aef7894 powerdevil-5.15.0.tar.xz
939ec9bc31bb3c89a73163950bdcedda plasma-desktop-5.15.0.tar.xz
d7b299906680e0b564ff24f5c0d70f27 kdeplasma-addons-5.15.0.tar.xz
92751cff053861a46f58d5ca8837cb65 kgamma5-5.15.0.tar.xz
f6a267d3e76056a70abc262963f10ed5 ksshaskpass-5.15.0.tar.xz
#f910c1c8e687ddade3c161e9b6b9b598 plasma-sdk-5.15.0.tar.xz
19e3f3cb0c8341039f9855e79b9f395c sddm-kcm-5.15.0.tar.xz
9755f8d9e1c84fcf105b464b513bb269 user-manager-5.15.0.tar.xz
d7135447c459e8c0bdb5d1fb1d703c01 discover-5.15.0.tar.xz
#745357574864bd167cff7b294486e145 breeze-grub-5.15.0.tar.xz
#a31d2ba0c628cf40d5102c14930a353c breeze-plymouth-5.15.0.tar.xz
885978ef5cae1c843673be511998fe22 kactivitymanagerd-5.15.0.tar.xz
3fe2706c6c26f26d9aa38fb658763c9f plasma-integration-5.15.0.tar.xz
e8d58c1860a29905fcfb0933de163231 plasma-tests-5.15.0.tar.xz
710233d7a0cb25b66caba2d496f706ba plymouth-kcm-5.15.0.tar.xz
78c04d7c16031002fb373a53ba75514a xdg-desktop-portal-kde-5.15.0.tar.xz
b1c8325c6a26a2b3f48b4adb6ce0a533 drkonqi-5.15.0.tar.xz
3241eed0c5938ecb07c7b6462179fb9b plasma-vault-5.15.0.tar.xz
90c0b196206104b28def99c770db4ac1 plasma-browser-integration-5.15.0.tar.xz
7033a941eef914415feea7051bf1e42f kde-cli-tools-5.15.0.tar.xz
580f675f1f03e5d2f4aec5cd6eebfe5f systemsettings-5.15.0.tar.xz
EOF
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
while read -r line; do

if grep $line plasma-all.log &> /dev/null; then continue; fi

# Get the file name, ignoring comments and blank lines
if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
file=$(echo $line | cut -d" " -f2)

pkg=$(echo $file|sed 's|^.*/||') # Remove directory
packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

tar -xf $file
pushd $packagedir

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_TESTING=OFF \
-Wno-dev .. &&

make
as_root make install
popd


as_root rm -rf $packagedir
as_root /sbin/ldconfig

echo $line >> plasma-all.log
done < plasma-5.15.0.md5



install -dvm 755 /usr/share/xsessions &&
cd /usr/share/xsessions/ &&
[ -e plasma.desktop ] ||
as_root ln -sfv /usr/share/xsessions/plasma.desktop

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/pam.d/kde << "EOF" 
# Begin /etc/pam.d/kde

auth requisite pam_nologin.so
auth required pam_env.so

auth required pam_succeed_if.so uid >= 1000 quiet
auth include system-auth

account include system-account
password include system-password
session include system-session

# End /etc/pam.d/kde
EOF

cat > /etc/pam.d/kde-np << "EOF" 
# Begin /etc/pam.d/kde-np

auth requisite pam_nologin.so
auth required pam_env.so

auth required pam_succeed_if.so uid >= 1000 quiet
auth required pam_permit.so

account include system-account
password include system-password
session include system-session

# End /etc/pam.d/kde-np
EOF

cat > /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sudo sed '/^Name=/s/Plasma/Plasma on Xorg/' -i /usr/share/xsessions/plasma.desktop
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rm $SOURCE_DIR/plasma-all.log

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
