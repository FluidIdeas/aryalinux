#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REC:graphviz
#OPT:dbus
#OPT:libxslt

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vala/0.42/vala-0.42.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vala/0.42/vala-0.42.4.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/vala-0.42.4-avoid_graphviz-1.patch

NAME=vala
VERSION=0.42.4
URL=http://ftp.gnome.org/pub/gnome/sources/vala/0.42/vala-0.42.4.tar.xz

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

patch -p1 -i ../vala-0.42.4-avoid_graphviz-1.patch &&
ACLOCAL= autoreconf -fiv
./configure --prefix=/usr &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
