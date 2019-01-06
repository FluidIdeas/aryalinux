#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REC:gnupg
#REC:gobject-introspection
#REC:gtk3
#REC:libxslt
#REC:vala
#OPT:gtk-doc
#OPT:valgrind

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz

NAME=gcr
VERSION=3.28.0
URL=http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.0.tar.xz

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

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --without-gtk-doc &&
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
