#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib


cd $SOURCE_DIR

wget -nc https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-60.tar.xz
wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.10-60.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/ImageMagick-6.9.10-60-libs_only-1.patch


NAME=imagemagick6
VERSION=6.9.1
URL=https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-60.tar.xz
SECTION="Miscellaneous"

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


patch -Np1 -i ../ImageMagick-6.9.10-60-libs_only-1.patch &&
autoreconf -fi                                          &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --disable-static  &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.10 install-libs-only
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

