#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxslt
#REQ:pcre
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.6.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/glib-2.60.6-skip_warnings-1.patch


NAME=glib2
VERSION=2.60.6
URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.6.tar.xz
SECTION="General Libraries"
DESCRIPTION="The GLib package contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for such runtime functionality as an event loop, threads, dynamic loading and an object system."

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

echo $USER > /tmp/currentuser


patch -Np1 -i ../glib-2.60.6-skip_warnings-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr      \
      -Dman=true         \
      -Dselinux=disabled \
      ..                 &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

mkdir -p /usr/share/doc/glib-2.60.6 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.60.6
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

