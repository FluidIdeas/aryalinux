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
url=http://download.kde.org/stable/plasma/5.15.3/
wget -nc -r -nH -nd -A '*.xz' -np $url
cat > plasma-5.15.3.md5 << "EOF"
b0cbc29002c38525f06e25926e41ce46 kdecoration-5.15.3.tar.xz
705f767f74d225a7d3e54863c28e8774 libkscreen-5.15.3.tar.xz
94d5a8505d3ecc69726aa9deb592bf97 libksysguard-5.15.3.tar.xz
9c11d520682160d4704cddb8386d3de8 breeze-5.15.3.tar.xz
b369b343d6dd4ef3af6d18340a83f308 breeze-gtk-5.15.3.tar.xz
d7ae9eaa8ff3208df01935fc0cd0c28a kscreenlocker-5.15.3.tar.xz
b0224262aaea0611a5304e9586d9ddbf oxygen-5.15.3.tar.xz
8064140c272452f7610e35b714930ca4 kinfocenter-5.15.3.tar.xz
39a526781799088e251305f17945e784 ksysguard-5.15.3.tar.xz
d297109766835e43cea21af920b88b3c kwin-5.15.3.2.tar.xz
582ef2fb97a9020c09d86118c04f3b0a plasma-workspace-5.15.3.tar.xz
7bb9a0a7cb5c751d1a94fcf9cb260bd4 bluedevil-5.15.3.tar.xz
fc76a4f8bdb2a031fdadff946514ae3d kde-gtk-config-5.15.3.tar.xz
9eebf70f99a2eb0d0a62285d47a8542e khotkeys-5.15.3.tar.xz
50e642a3d5949443e161ea0d4eeaadea kmenuedit-5.15.3.tar.xz
0efcace3965f868e4b474f501c4c3130 kscreen-5.15.3.tar.xz
6ebd5b3e62be468b4a5841bcce624093 kwallet-pam-5.15.3.tar.xz
f5ceb5dbfcf2d3f590b9115c446b35df kwayland-integration-5.15.3.tar.xz
c568256c56e2a2fa22e642a8bd43bfa5 kwrited-5.15.3.tar.xz
95d1078a08dcf21266a9cce51bac9dc6 milou-5.15.3.tar.xz
46492d319950a48f3a192f1d883a4020 plasma-nm-5.15.3.tar.xz
97752f6f9a57d39eaa1b68b99f5880af plasma-pa-5.15.3.tar.xz
7006c1d844dd8d23fa6c4e18af645860 plasma-workspace-wallpapers-5.15.3.tar.xz
4b364062f59fb9599ef7c60fbcc1d9e2 polkit-kde-agent-1-5.15.3.tar.xz
72da38b000b84ebb350b2842c22438bb powerdevil-5.15.3.tar.xz
0aedba1ccd551bf3137cbadedf140c3c plasma-desktop-5.15.3.2.tar.xz
a1b032662fd6267b7bf0e8a0ff627db0 kdeplasma-addons-5.15.3.tar.xz
cb4e1b8f8d4b4f3bf53a35b7bb02fe48 kgamma5-5.15.3.tar.xz
86f4c45eac9db936b22b84cb75c35598 ksshaskpass-5.15.3.tar.xz
#b625e5c98588b20c842c8c750abf9df2 plasma-sdk-5.15.3.tar.xz
b2a458ec19d39cdecc969b1e5ad226dd sddm-kcm-5.15.3.tar.xz
c1b015e2c94995c1e336204900d77929 user-manager-5.15.3.tar.xz
1ffd8fe39532ef5093e42d4b330de5dd discover-5.15.3.tar.xz
#9dd691cded8af750f779f5479dc898e9 breeze-grub-5.15.3.tar.xz
#2f48a4f199780cc8fe3d31eda54034e7 breeze-plymouth-5.15.3.tar.xz
242dbc1fc363e90dad8350c9138918c3 kactivitymanagerd-5.15.3.tar.xz
509f18cd766b6a63de42eaf3d8d91946 plasma-integration-5.15.3.tar.xz
b92720b576ce939c033e21986b59abe2 plasma-tests-5.15.3.tar.xz
a19b7e09a04dd5b6551fb05932fb0050 plymouth-kcm-5.15.3.tar.xz
2492e7e238944e5f573857a8a8d66276 xdg-desktop-portal-kde-5.15.3.tar.xz
79eeaeaf73d8002c536d9b9f398042db drkonqi-5.15.3.tar.xz
f2c1e4e95bf01106c2f9b434366258c3 plasma-vault-5.15.3.tar.xz
dcede75af2b44e7dba52164f52a8a37a plasma-browser-integration-5.15.3.tar.xz
882890f64e5143e67e061f6267feea5f kde-cli-tools-5.15.3.tar.xz
4f27f409f8660e5656cfae2c7fe2c4a3 systemsettings-5.15.3.2.tar.xz
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
done < plasma-5.15.3.md5



install -dvm 755 /usr/share/xsessions &&
cd /usr/share/xsessions/ &&
[ -e plasma.desktop ] ||
as_root ln -sfv /usr/share/xsessions/plasma.desktop

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/pam.d/kde << "EOF" 
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
