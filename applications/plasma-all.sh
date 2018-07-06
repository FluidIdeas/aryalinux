#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde"
NAME="plasma-all"
VERSION="5.13.2"

#REQ:fontforge
#REQ:gtk2
#REQ:gtk3
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
#REQ:kframeworks5
#REC:libdbusmenu-qt
#REC:libcanberra
#REC:x7driver
#REC:linux-pam
#REC:lm_sensors
#REC:oxygen-icons5
#REC:pciutils
#OPT:glu
#OPT:x7driver


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

url=http://download.kde.org/stable/plasma/$VERSION/
wget -nc -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > plasma-$VERSION.md5 << EOF
bc2dd43ace2d8674f1d0468e1205474a kde-cli-tools-$VERSION.tar.xz
d72584ff8363c903ea58b2d56cab965f kdecoration-$VERSION.tar.xz
f40f3015e4c0cbadba893ea9aec37ec2 libkscreen-$VERSION.tar.xz
2c1234454ea8ca8f58de237600674959 libksysguard-$VERSION.tar.xz
1bb1a2462640daf062af923783709093 breeze-$VERSION.tar.xz
808ef73cc2c687d4d34552c5e98ec699 breeze-gtk-$VERSION.tar.xz
77df269b8566cf688b1945a9b53e3959 kscreenlocker-$VERSION.tar.xz
2842c0205ab580e4ac3dc61a8ab581be oxygen-$VERSION.tar.xz
e9d2bdeadcbd378f12a2e54c6b3b9224 kinfocenter-$VERSION.tar.xz
99d46f170a9143883c207e0a8999e268 ksysguard-$VERSION.tar.xz
e1dd04fcaf1abd31df89d037af4d2258 kwin-$VERSION.tar.xz
2b5f4dbc85193941708509e51.181f14 systemsettings-$VERSION.tar.xz
5ed64282b5aa36bb77bd3a89334b851d plasma-workspace-$VERSION.tar.xz
57c1e8aa62aa5791102e94160bb5e2b3 bluedevil-$VERSION.tar.xz
12c5bc74c567f65fbb11907909752ba2 kde-gtk-config-$VERSION.tar.xz
db39c52e7bdf1ec21888aae5f9f3113a khotkeys-$VERSION.tar.xz
fa1edaf0339a013b0884a5ec774e132d kmenuedit-$VERSION.tar.xz
369255dcf3f657595a4b2c0ec156d458 kscreen-$VERSION.tar.xz
607eb34cfafca62da92dbb596f999cae kwallet-pam-$VERSION.tar.xz
4ec2115eec3883e56041$VERSION8f910e1 kwayland-integration-$VERSION.tar.xz
35e622ea295b35c72e266d3e10b2022b kwrited-$VERSION.tar.xz
c8c40727b9077d9692c2e67b85afaa7d milou-$VERSION.tar.xz
1956f0eb29ce1e91f5fdf3ac8b72e40e plasma-nm-$VERSION.tar.xz
2820e9cb6c54f01115013606dea7ef7b plasma-pa-$VERSION.tar.xz
98f2f023cc30116f0e677e752fb6220c plasma-workspace-wallpapers-$VERSION.tar.xz
b2fa225d57fcf8579322d58cf43a8759 polkit-kde-agent-1-$VERSION.tar.xz
4b93bfa172760c25c6a4e135b555fbe8 powerdevil-$VERSION.tar.xz
1b97771749effa32aee19ed789e67ddd plasma-desktop-$VERSION.tar.xz
3083f945aebfc156ba0e8b64db4615b0 kdeplasma-addons-$VERSION.tar.xz
9f336c20cee1f1e5db98ca95eea7ccd5 kgamma5-$VERSION.tar.xz
8048a6ec5e69327691236d980a74b2a2 ksshaskpass-$VERSION.tar.xz
#a92b968f0ebd5f35cb7483679a54520b plasma-mediacenter-$VERSION.tar.xz
#e92b6d4c644591b16f700303eacd3ffe plasma-sdk-$VERSION.tar.xz
e82aed1e04ae3e39fa91b7c16e4338e2 sddm-kcm-$VERSION.tar.xz
635eef411376423f8f746ae41bb90f1b user-manager-$VERSION.tar.xz
9188f0f3a3c802ffd25f4c0dcb0abdba discover-$VERSION.tar.xz
#b4a278e5af4cc4b804258a3aeb9d7ce2 breeze-grub-$VERSION.tar.xz
#d9fc477b250f0ae855a0e9bdb193b51a breeze-plymouth-$VERSION.tar.xz
9ec5c70fd1e5fdc12bf35e1511948543 kactivitymanagerd-$VERSION.tar.xz
5f950d13d8715162ea4bdfec73e06b7d plasma-integration-$VERSION.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root

touch /tmp/plasma-build-list
while read -r line; do
    if grep "$line" /tmp/plasma-build-list; then continue; fi
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    # Correct the name of the extracted directory
    case $packagedir in
      plasma-workspace-5.6.5.1 )
        packagedir=plasma-workspace-5.6.5
        ;;
    esac
    tar -xf $file
    pushd $packagedir
       mkdir build
       cd    build
       cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
             -DCMAKE_BUILD_TYPE=Release         \
             -DLIB_INSTALL_DIR=lib              \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&
        make "-j`nproc`" || make
        as_root make install
    popd
    as_root rm -rf $packagedir
    as_root /sbin/ldconfig
    echo "$line" >> /tmp/plasma-build-list
done < plasma-$VERSION.md5
cd /opt/kf5/share/plasma/plasmoids
for j in $(find -name \*.js); do
  as_root ln -sfv ../code/$(basename $j) $(dirname $j)/../ui/
done


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
