#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Itstool extracts messages from XMLbr3ak files and outputs PO template files, then merges translations frombr3ak MO files to create translated XML files. It determines what tobr3ak translate and how to chunk it into messages using the W3Cbr3ak Internationalization Tag Set (ITS).br3ak"
SECTION="pst"
VERSION=2.0.4
NAME="itstool"

#REQ:docbook


cd $SOURCE_DIR

URL=http://files.itstool.org/itstool/itstool-2.0.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://files.itstool.org/itstool/itstool-2.0.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/itstool/itstool-2.0.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/itstool-2.0.4-segfault-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/itstool/itstool-2.0.4-segfault-1.patch

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

patch -Np1 -i ../itstool-2.0.4-segfault-1.patch &&
PYTHON=/usr/bin/python3 ./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
