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
2ffb11f91a451f90c034b5b657d38563  libksysguard-$VERSION.tar.xz
7a6426a12788a1dc5fceb3ed0cf15818  kdecoration-$VERSION.tar.xz
30afafc98d6d3eecec15c1bad3ce0362  kscreenlocker-$VERSION.tar.xz
39cc7321fe28c2b4a76426da8a830d7c  kwin-$VERSION.tar.xz
28906f048a968798f7311c1068aebb8b  plasma-workspace-$VERSION.tar.xz
15e8b3abd34c7bed89247dcd89677da9  kde-cli-tools-$VERSION.tar.xz
1e3b3aa0026bf51121fa36f4380db6e5  libkscreen-$VERSION.tar.xz
45cc26a47b5c742e93ba17e59d72d91a  breeze-$VERSION.tar.xz
4df4338cb8781e068e8b53987430cbda  breeze-gtk-$VERSION.tar.xz
7622748eafe631e46574e44ba53bdaea  oxygen-$VERSION.tar.xz
5d0f3d5844ac31f2665ed0d5966d7751  kinfocenter-$VERSION.tar.xz
25bfe4cb9bbb782c938f92963ca1cd59  ksysguard-$VERSION.tar.xz
08b5ebd84ee25d2306d30e1afe33f924  systemsettings-$VERSION.tar.xz
60e92f4d444cba7e31041bf9c426d1aa  bluedevil-$VERSION.tar.xz
26706a36cb19c270281a0b69f8ab2609  kde-gtk-config-$VERSION.tar.xz
af8bda38832760df6bc0f07aa784f8f3  khotkeys-$VERSION.tar.xz
450833cf1ccd244c40102cd249e73d2b  kmenuedit-$VERSION.tar.xz
bdd7f9036220e39f23b1c57cb373174d  kscreen-$VERSION.tar.xz
667a9ef9a5f5fa4664e337d405cdfdb6  kwallet-pam-$VERSION.tar.xz
dffa9e29a181d6d70bcf20a5d9de0781  kwayland-integration-$VERSION.tar.xz
bc51d2068b1f442214059059761db068  kwrited-$VERSION.tar.xz
a6297963718e9315e72e1711e4f71e5c  milou-$VERSION.tar.xz
2f52d77ade3582ce05bc58c4d2ea2677  plasma-nm-$VERSION.tar.xz
0104e49c0e6332fdec3a61ddc9732c44  plasma-pa-$VERSION.tar.xz
30c03aeab0d69d87d08a5b1e57468f8c  plasma-workspace-wallpapers-$VERSION.tar.xz
b42ed1b4dfbc7f594529b12b4659a8e1  polkit-kde-agent-1-$VERSION.tar.xz
5546090caa4cf11656091ae229351551  powerdevil-$VERSION.tar.xz
bfcf9e48662c34d732b5f498b4627819  plasma-desktop-$VERSION.tar.xz
d16a91ea15fc12e7c18d420370ad0bd6  kdeplasma-addons-$VERSION.tar.xz
0ce29fe24ed752a36ce7fb6ff1be9fb1  kgamma5-$VERSION.tar.xz
805ba1b34c292e43f7791796d552a48c  ksshaskpass-$VERSION.tar.xz
#e7de5fcb703e47edc4f3fa5c9094dd9a  plasma-sdk-$VERSION.tar.xz
ba33b3187ddee122be32ffe0445564fb  sddm-kcm-$VERSION.tar.xz
f4268471d391b2fb7f51818b7b96c9f6  user-manager-$VERSION.tar.xz
9101bdf4a6664dddc0e15b8fda4681e9  discover-$VERSION.tar.xz
#420c6369da5761fcee359cce8693badd  breeze-grub-$VERSION.tar.xz
#dbba7538a93056a57f52ecfe31eaf8cb  breeze-plymouth-$VERSION.tar.xz
d28812344e8e0f47b1121f56d3e13750  kactivitymanagerd-$VERSION.tar.xz
df9ade96432e4f5eb968e12ed7a7a72c  plasma-integration-$VERSION.tar.xz
ed8dbcc85b1a1f74dc04b2be5e64b36a  plasma-tests-$VERSION.tar.xz
e1a1a785e1f6c4a64af95e4989a07bea  plymouth-kcm-$VERSION.tar.xz
f9081bb509a565f3d11f28cd6b0a0914  xdg-desktop-portal-kde-$VERSION.tar.xz
08c841d2ea5b29ec4ffca146deeac75a  drkonqi-$VERSION.tar.xz
550e6df7522a10e5262136a54b88a254  plasma-vault-$VERSION.tar.xz
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
       mkdir -pv build
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
#cd /opt/kf5/share/plasma/plasmoids
#for j in $(find -name \*.js); do
#  as_root ln -sfv ../code/$(basename $j) $(dirname $j)/../ui/
#done


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
