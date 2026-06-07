#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:appstream
#REQ:gegl
#REQ:gexiv2
#REQ:gtk3
#REQ:harfbuzz
#REQ:libxml2
#REQ:lcms2
#REQ:poppler
#REQ:graphviz
#REQ:iso-codes
#REQ:python-modules#pygobject3
#REQ:xdg-utils

cd $SOURCE_DIR
NAME=gimp
VERSION=3.0.6
URL=https://download.gimp.org/gimp/v3.0/gimp-3.0.6.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gimp.org/gimp/v3.0/gimp-3.0.6.tar.xz


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

patch -Np1 -i ../gimp-3.0.6-security_fixes-1.patch
mkdir gimp-build
cd    gimp-build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D headless-tests=disabled
ninja
gtk-update-icon-cache -qtf /usr/share/icons/hicolor
update-desktop-database -q
tar -xf ../../gimp-help-3.0.2.tar.bz2
cd gimp-help-3.0.2

sed -i 's/import libxml2//' configure
ALL_LINGUAS="en" \
./configure --prefix=/usr
make
rm -rf /usr/{lib,share}/gimp/3.0
rm -f  /usr/share/gir-1.0/Gimp-3.0.gir
rm -f  /usr/lib/girepository-1.0/Gimp-3.0.typelib
rm -f  /usr/lib/libgimp*-3.0.so*
chown -R root:root /usr/share/gimp/3.0/help


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd