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
#REQ:python2
#REQ:qca
#REQ:taglib
#REQ:xcb-util-cursor
#REC:libdbusmenu-qt
#REC:libcanberra
#REC:libinput
#REC:linux-pam
#REC:lm_sensors
#REC:oxygen-icons5
#REC:pciutils
#OPT:glu
#OPT:ibus
#OPT:xorg-synaptics-driver

cd $SOURCE_DIR


NAME=plasma-all
VERSION=""
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
url=http://download.kde.org/stable/plasma/5.14.4/
wget -nc -r -nH -nd -A '*.xz' -np $url
cat > plasma-5.14.4.md5 << "EOF"
014d15755600481d8bd2125d82776510 kdecoration-5.14.4.tar.xz
6cafec0732d42a11618b0f7843b9cdb7 libkscreen-5.14.4.tar.xz
8b43076fe3d8845d7f890721a90b8210 libksysguard-5.14.4.tar.xz
4bea8ee0b3b165235ebfc2c02be6dc1c breeze-5.14.4.tar.xz
858a3f7cbec03e40fbd3ee6bcf24ea85 breeze-gtk-5.14.4.tar.xz
f46412c02e11d53723c89a1f7505a3dd kscreenlocker-5.14.4.tar.xz
a194273fcb39e57b694121d258188a7a oxygen-5.14.4.tar.xz
34c5a84a8d6a135cb947b6ecd17803ee kinfocenter-5.14.4.tar.xz
abc6602d3f0d986a07d8b00684599ca9 ksysguard-5.14.4.tar.xz
3d9ce77dd5671b514d9943c5119fca61 kwin-5.14.4.tar.xz
eaeaeaf57be7d45752ec92f0b5beda0b plasma-workspace-5.14.4.tar.xz
fe29af65a55d434bfb5a1806f7ca61b0 bluedevil-5.14.4.tar.xz
f2bf818be2ebeca91985e01278f6d93f kde-gtk-config-5.14.4.tar.xz
c38e8d0902ba37f5308cb7f05047072b khotkeys-5.14.4.tar.xz
68bb90533998367a5a207132b91b0ac3 kmenuedit-5.14.4.tar.xz
2fd69bedd600e7bfa8e4cae6e2425fc9 kscreen-5.14.4.tar.xz
d548ae1d4b1850cc65093128a411304a kwallet-pam-5.14.4.tar.xz
16d278360004a80db9c5a6baa2f7781b kwayland-integration-5.14.4.tar.xz
9f36e858f57d24098c2ddb5987bf200e kwrited-5.14.4.tar.xz
ea0c7fe6cf49049b9a68b9d0094634b9 milou-5.14.4.tar.xz
3e1200ad29cae12d7672902164449403 plasma-nm-5.14.4.tar.xz
bf60a089095cfeca423a2e1dfc7fc627 plasma-pa-5.14.4.tar.xz
5896ef78ebf9b4784ed1fb44c4af1d69 plasma-workspace-wallpapers-5.14.4.tar.xz
25e9a3d1745d0c11d8568074229671a3 polkit-kde-agent-1-5.14.4.tar.xz
fdb962c816db14a40c5e455c6f25523a powerdevil-5.14.4.tar.xz
#2db6c86391fcb083a0ff079a14875821 plasma-desktop-5.14.4.tar.xz
420adc0e141435398e116e60da50d7ff plasma-desktop-5.14.4.1.tar.xz
16c0b5f4737a9fce99018d49858cb47d kdeplasma-addons-5.14.4.tar.xz
3c3ba960cca9349126dcafcbf702eab1 kgamma5-5.14.4.tar.xz
878b25b3c87b13030b303c7f667c450a ksshaskpass-5.14.4.tar.xz
#305356781ac6d6fc4bd1708b4c6f756b plasma-sdk-5.14.4.tar.xz
1a28a56b8b76b2c84c9d880f546274c4 sddm-kcm-5.14.4.tar.xz
fbd60bfb9e66c72311e233817b94e809 user-manager-5.14.4.tar.xz
e14211fc2b0d995d3cf142168056c144 discover-5.14.4.tar.xz
#86462c52fb106e9ed753822c48456c94 breeze-grub-5.14.4.tar.xz
#9a16fa97036b5de9fa0d68d6c2d6e822 breeze-plymouth-5.14.4.tar.xz
d2ef43f119c8afa91745092f649205ff kactivitymanagerd-5.14.4.tar.xz
14289404eeff5fd571aefbe2a025dc86 plasma-integration-5.14.4.tar.xz
78aaa3b82fe3010be8ff90a44bdd7e8a plasma-tests-5.14.4.tar.xz
13dd25e88e6fffbff6dad7ae2e49110d plymouth-kcm-5.14.4.tar.xz
9df4568014b9f3bc91577db4205d40d4 xdg-desktop-portal-kde-5.14.4.tar.xz
633cc3750606ad94f2c8f49a0fd3a656 drkonqi-5.14.4.tar.xz
cd1c28ad7d047861634fa091cec5cd29 plasma-vault-5.14.4.tar.xz
7a1b10a5dc4b28600a9f3f13de800bd5 plasma-browser-integration-5.14.4.tar.xz
d008931a914d5748da62f6667915c7d6 kde-cli-tools-5.14.4.tar.xz
1c119822295205f625c7fcc6ea7b01bb systemsettings-5.14.4.tar.xz
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

echo $line > plasma-all.log
done < plasma-5.14.4.md5



cd /usr/share/xsessions/
[ -e plasma.desktop ] || as_root ln -sfv /usr/share/xsessions/plasma.desktop

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

sudo sed '/^Name=/s/Plasma/Plasma on Xorg/' -i /usr/share/xsessions/plasma.desktop

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
