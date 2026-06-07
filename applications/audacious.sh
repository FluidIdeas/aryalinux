#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:gtk3
#REQ:mpg123
#REQ:neon

cd $SOURCE_DIR
NAME=audacious
VERSION=4.5.1
URL=https://distfiles.audacious-media-player.org/audacious-4.5.1.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://distfiles.audacious-media-player.org/audacious-4.5.1.tar.bz2


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

mkdir build
cd    build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gtk=true         \
      -D qt=true          \
      -D buildstamp=BLFS  \
      -D libarchive=true
ninja
tar -xf ../../audacious-plugins-4.5.1.tar.bz2
cd audacious-plugins-4.5.1
mkdir build
cd    build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gtk=true         \
      -D qt=true          \
      -D opus=false       \
      -D wavpack=false
ninja


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd