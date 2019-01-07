#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REC:gobject-introspection
#REC:vala
#OPT:cyrus-sasl
#OPT:pulseaudio

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz

NAME=gtk-vnc
VERSION=0.7.2
URL=http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz

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
--with-gtk=3.0 \
--enable-vala \
--without-sasl &&
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
