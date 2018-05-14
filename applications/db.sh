#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Berkeley DB package containsbr3ak programs and utilities used by many other applications for databasebr3ak related functions.br3ak"
SECTION="server"
VERSION=6.2.32
NAME="db"

#OPT:tcl


cd $SOURCE_DIR

URL=http://download.oracle.com/berkeley-db/db-6.2.32.tar.gz

if [ ! -z $URL ]
then
wget -nc http://download.oracle.com/berkeley-db/db-6.2.32.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/db-6.2.32.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/db/db-6.2.32.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.2.32.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.2.32.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.2.32.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.2.32.tar.gz

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

cd build_unix                        &&
../dist/configure --prefix=/usr      \
                  --enable-compat185 \
                  --enable-dbm       \
                  --disable-static   \
                  --enable-cxx       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/db-6.2.32 install &&
chown -v -R root:root                        \
      /usr/bin/db_*                          \
      /usr/include/db{,_185,_cxx}.h          \
      /usr/lib/libdb*.{so,la}                \
      /usr/share/doc/db-6.2.32

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
