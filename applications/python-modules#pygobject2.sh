#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=2.28.7
NAME="python-modules#pygobject2"

#REQ:glib2
#REQ:python-modules#pycairo
#OPT:gobject-introspection
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.7.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.7.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

./configure --prefix=/usr --disable-introspection &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
