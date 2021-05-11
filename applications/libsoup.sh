#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib-networking
#REQ:libpsl
#REQ:libxml2
#REQ:sqlite
#REQ:gobject-introspection
#REQ:sysprof
#REQ:vala


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/libsoup/2.72/libsoup-2.72.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libsoup/2.72/libsoup-2.72.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/libsoup-2.72.0-testsuite_fix-1.patch


NAME=libsoup
VERSION=2.72.0
URL=https://download.gnome.org/sources/libsoup/2.72/libsoup-2.72.0.tar.xz
SECTION="Networking Libraries"
DESCRIPTION="The libsoup is a HTTP client/server library for GNOME. It uses GObject and the GLib main loop to integrate with GNOME applications and it also has an asynchronous API for use in threaded applications."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


patch -Np1 -i ../libsoup-2.72.0-testsuite_fix-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr -Dvapi=enabled -Dgssapi=disabled .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

