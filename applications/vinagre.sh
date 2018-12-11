#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk-vnc
#REQ:itstool
#REQ:libsecret
#REC:telepathy-glib
#REC:vala
#REC:vte
#OPT:avahi

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz

NAME=vinagre
VERSION=3.22.0
URL=http://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz

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

./configure --prefix=/usr \
            --enable-compile-warnings=minimum &&
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
