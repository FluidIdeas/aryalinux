#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REQ:libgpg-error
#REC:gobject-introspection
#REC:libidn2
#OPT:docbook-utils
#OPT:gtk-doc
#OPT:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.3.tar.xz

NAME=gmime3
VERSION=3.2.3
URL=http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.3.tar.xz

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
