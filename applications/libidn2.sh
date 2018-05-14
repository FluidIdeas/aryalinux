#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libidn2 is a package designed forbr3ak internationalized string handling based on standards from thebr3ak Internet Engineering Task Force (IETF)'s IDN working group,br3ak designed for internationalized domain names.br3ak"
SECTION="general"
VERSION=2.0.4
NAME="libidn2"

#REQ:libunistring
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn2-2.0.4.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
