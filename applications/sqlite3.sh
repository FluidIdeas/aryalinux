#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="sqlite3"
VERSION="3110000"
DESCRIPTION="SQLite is a relational database management system contained in a C programming library."

#OPT:unzip


cd $SOURCE_DIR

URL=http://sqlite.org/2016/sqlite-autoconf-3110000.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3110000.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3110000.zip || wget -nc http://sqlite.org/2016/sqlite-doc-3110000.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-doc-3110000.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3110000.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3110000.zip
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3110000.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3110000.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3110000.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-autoconf-3110000.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3110000.tar.gz || wget -nc http://sqlite.org/2016/sqlite-autoconf-3110000.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

unzip -q ../sqlite-doc-3110000.zip


./configure --prefix=/usr --disable-static        \
            CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
			-DSQLITE_ENABLE_FTS3_PARENTHESIS=1    \
			-DSQLITE_ENABLE_FTS3_TOKENIZER=1      \
            -DSQLITE_ENABLE_COLUMN_METADATA=1     \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
            -DSQLITE_SECURE_DELETE=1              \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1" &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/sqlite-3.11.0 &&
cp -v -R sqlite-doc-3110000/* /usr/share/doc/sqlite-3.11.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
