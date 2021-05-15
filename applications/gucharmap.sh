#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:desktop-file-utils
#REQ:gtk3
#REQ:itstool
#REQ:unzip
#REQ:wget
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

NAME=gucharmap
VERSION=12.0.1
URL=https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Gucharmap is a Unicode character map and font viewer. It allows you to browse through all the available Unicode characters and categories for the installed fonts, and to examine their detailed properties. It is an easy way to find the character you might only know by its Unicode name or code point."


mkdir -pv $NAME
pushd $NAME

wget -nc https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz


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


LIBS="-ldl"               \
./configure --prefix=/usr \
            --enable-vala \
            --with-unicode-data=download &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd