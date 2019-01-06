#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libunique-1.1.6-upstream_fixes-1.patch

NAME=libunique
VERSION=1.1.6.
URL=http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2

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

patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch &&
autoreconf -fi &&

./configure --prefix=/usr \
--disable-dbus \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
