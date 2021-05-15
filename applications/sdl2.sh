#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxkbcommon
#REQ:wayland-protocols
#REQ:x7lib


cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc https://www.libsdl.org/release/SDL2-2.0.14.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/SDL2-2.0.14-opengl_include_fix-1.patch


NAME=sdl2
VERSION=2.0.14
URL=https://www.libsdl.org/release/SDL2-2.0.14.tar.gz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The Simple DirectMedia Layer Version 2 (SDL2 for short) is a cross-platform library designed to make it easy to write multimedia software, such as games and emulators."

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


case $(uname -m) in
   i?86) patch -Np1 -i ../SDL2-2.0.14-opengl_include_fix-1.patch ;;
esac
./configure --prefix=/usr &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install              &&
rm -v /usr/lib/libSDL2*.a
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd