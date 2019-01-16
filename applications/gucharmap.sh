#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:desktop-file-utils
#REQ:gtk3
#REQ:itstool
#REQ:unzip
#REQ:wget
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz

NAME=gucharmap
VERSION=11.0.3
URL=http://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

LIBS="-ldl" \
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
