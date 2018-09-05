#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=1.2.8
NAME="python-modules#dbus-python"

#REQ:dbus
#REQ:glib2
#OPT:python2
#OPT:python-modules#docutils


cd $SOURCE_DIR

URL=https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz

if [ ! -z $URL ]
then
wget -nc https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.8.tar.gz

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
PYTHON=/usr/bin/python     \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd

mkdir python3 &&
pushd python3 &&
PYTHON=/usr/bin/python3    \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python2 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
