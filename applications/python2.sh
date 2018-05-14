#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Python 2 package contains thebr3ak Python development environment. Itbr3ak is useful for object-oriented programming, writing scripts,br3ak prototyping large programs or developing entire applications. Thisbr3ak version is for backward compatibility with other dependentbr3ak packages.br3ak"
SECTION="general"
VERSION=2.7.14
NAME="python2"

#OPT:bluez
#OPT:valgrind
#OPT:sqlite
#OPT:tk


cd $SOURCE_DIR

URL=https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-2.7.14.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Python/Python-2.7.14.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.14.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.14.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.14.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.14.tar.xz
wget -nc https://docs.python.org/ftp/python/doc/2.7.14/python-2.7.14-docs-html.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.14-docs-html.tar.bz2

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

sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist


./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/python-2.7.14 &&
tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.14 \
    -xvf ../python-2.7.14-docs-html.tar.bz2 &&
find /usr/share/doc/python-2.7.14 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.14 -type f -exec chmod 0644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-2.7.14

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
