#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl
#REQ:libevent
#REQ:libpsl
#REQ:gtkmm3


cd $SOURCE_DIR

NAME=transmission
VERSION=4.0.2
URL=https://github.com/transmission/transmission/releases/download/4.0.2/transmission-4.0.2.tar.xz
SECTION="Other X-based Programs"
DESCRIPTION="Transmission is a cross-platform, open source BitTorrent client. This is useful for downloading large files (such as Linux ISOs) and reduces the need for the distributors to provide server bandwidth."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/transmission/transmission/releases/download/4.0.2/transmission-4.0.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/6.0/transmission-4.0.2-fix-paste-shortcut-1.patch


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


patch -Np1 -i ../transmission-4.0.2-fix-paste-shortcut-1.patch
sed -i 's/Control+V/Control+I/g' web/public_html/transmission-app.js
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/transmission-4.0.2 \
      .. &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rsvg-convert                                               \
   /usr/share/icons/hicolor/scalable/apps/transmission.svg \
   -o /usr/share/pixmaps/transmission.png
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd