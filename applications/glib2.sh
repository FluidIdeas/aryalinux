#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:libxslt
#REC:pcre
#REC:gobject-introspection
#OPT:dbus
#OPT:docbook
#OPT:docbook-xsl
#OPT:gtk-doc
#OPT:shared-mime-info
#OPT:desktop-file-utils

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.58/glib-2.58.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.58/glib-2.58.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/glib-2.58.2-skip_warnings-1.patch

NAME=glib2
VERSION=2.58.2
URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.58/glib-2.58.2.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

patch -Np1 -i ../glib-2.58.2-skip_warnings-1.patch
mkdir build-glib &&
cd build-glib &&

meson --prefix=/usr \
-Dman=true \
-Dselinux=false \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

mkdir -p /usr/share/doc/glib-2.58.2 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.58.2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
