#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gobject-introspection
#REQ:gtk3
#REC:python-modules#pygobject3
#OPT:gdb
#OPT:gtk-doc
#OPT:valgrind

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
wget -nc http://www.lua.org/ftp/lua-5.1.5.tar.gz

URL=http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz

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
