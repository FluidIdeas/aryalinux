#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk3
#REQ:libxml2
#REQ:pcre2
#REC:gobject-introspection
#REC:gnutls
#OPT:gtk-doc
#OPT:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.54/vte-0.54.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.54/vte-0.54.3.tar.xz

NAME=vte
VERSION=0.54.3
URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.54/vte-0.54.3.tar.xz

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

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-static       \
            --enable-introspection &&
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
