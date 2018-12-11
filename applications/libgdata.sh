#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:liboauth
#REQ:libsoup
#REQ:gtk3
#REQ:json-glib
#REQ:uhttpmock
#REQ:vala
#REC:gcr
#REC:git
#REC:gnome-online-accounts
#REC:gobject-introspection
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.9.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.9.tar.xz

NAME=libgdata
VERSION=0.17.9
URL=http://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.9.tar.xz

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

./configure --prefix=/usr --disable-static &&
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
