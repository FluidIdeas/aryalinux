#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=3.30.1
NAME="python-modules#pygobject3"

#REQ:gobject-introspection
#REQ:python-modules#pycairo


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/3.30/pygobject-3.30.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.30/pygobject-3.30.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.30/pygobject-3.30.1.tar.xz

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

mkdir python2 &&
pushd python2 &&
meson --prefix=/usr -Dpython=python2 .. &&
ninja &&
popd

mkdir python3 &&
pushd python3 &&
meson --prefix=/usr -Dpython=python3 &&
ninja &&
popd


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja -C python2 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja -C python3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
