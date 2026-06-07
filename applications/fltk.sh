#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:x7lib
#REQ:hicolor-icon-theme
#REQ:libjpeg
#REQ:libpng

cd $SOURCE_DIR
NAME=fltk
VERSION=1.4.4
URL=https://github.com/fltk/fltk/releases/download/release-1.4.4/fltk-1.4.4-source.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/fltk/fltk/releases/download/release-1.4.4/fltk-1.4.4-source.tar.gz


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

sed -i -e '/cat./d' documentation/Makefile
./configure --prefix=/usr --enable-shared
make
make -C documentation html
make docdir=/usr/share/doc/fltk-1.4.4 install
rm -vf /usr/lib/libfltk*.a
tar -C /usr/share/doc/fltk-1.4.4 --strip-components=4 -xf ../fltk-1.4.4-docs-html.tar.gz

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd