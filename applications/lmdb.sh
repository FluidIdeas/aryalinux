#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lmdb package is a fast,br3ak compact, key-value embedded data store. It uses memory-mappedbr3ak files, so it has the read performance of a pure in-memory databasebr3ak while still offering the persistence of standard disk-basedbr3ak databases, and is only limited to the size of the virtual addressbr3ak spacebr3ak"
SECTION="server"
VERSION=0.9.22
NAME="lmdb"



cd $SOURCE_DIR

URL=https://github.com/LMDB/lmdb/archive/LMDB_0.9.22.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/LMDB/lmdb/archive/LMDB_0.9.22.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.22.tar.gz

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

cd libraries/liblmdb &&
make                 &&
sed -i 's| liblmdb.a||' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
