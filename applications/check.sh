#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Check is a unit testing frameworkbr3ak for C. It was installed by LFS in the temporary /tools directory.br3ak These instructions install it permanently.br3ak"
SECTION="general"
VERSION=0.11.0
NAME="check"



cd $SOURCE_DIR

URL=https://github.com/libcheck/check/releases/download/0.11.0/check-0.11.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/libcheck/check/releases/download/0.11.0/check-0.11.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/check/check-0.11.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/check/check-0.11.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/check/check-0.11.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/check/check-0.11.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/check/check-0.11.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/check/check-0.11.0.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/check-0.11.0 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
