#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REC:gnome-keyring
#REC:gobject-introspection
#REC:libsecret
#REC:nautilus
#REC:poppler
#OPT:cups
#OPT:gnome-desktop
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libtiff
#OPT:texlive
#OPT:tl-installer

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz
wget -nc http://www.ibiblio.org/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz

NAME=evince
VERSION=3.28.2
URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz

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
--enable-compile-warnings=minimum \
--enable-introspection \
--disable-static &&
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
