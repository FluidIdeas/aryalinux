#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Python 3 package contains thebr3ak Python development environment.br3ak This is useful for object-oriented programming, writing scripts,br3ak prototyping large programs or developing entire applications.br3ak"
SECTION="general"
VERSION=3.7.0
NAME="python3"

#OPT:bluez
#OPT:gdb
#OPT:valgrind
#OPT:db
#OPT:sqlite


cd $SOURCE_DIR

URL=https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-3.7.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Python/Python-3.7.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-3.7.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-3.7.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-3.7.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-3.7.0.tar.xz

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

whoami > /tmp/currentuser

CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpython3.7m.so &&
chmod -v 755 /usr/lib/libpython3.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -svfn python-3.7.0 /usr/share/doc/python-3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-3/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
