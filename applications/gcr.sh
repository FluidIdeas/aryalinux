#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REQ:gnupg
#REQ:gobject-introspection
#REQ:gtk3
#REQ:libxslt
#REQ:vala


cd $SOURCE_DIR



NAME=gcr
VERSION=3.36.0

SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Gcr package contains libraries used for displaying certificates and accessing key stores. It also provides the viewer for crypto files on the GNOME Desktop."

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

git clone https://github.com/GNOME/gcr.git
cd gcr
sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml
mkdir builddir
meson --prefix=/usr
ninja
sudo ninja install
cd $SOURCE_DIR
sudo rm -rf gcr


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

