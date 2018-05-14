#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The chrpath modify the dynamicbr3ak library load path (rpath and runpath) of compiled programs andbr3ak libraries.br3ak"
SECTION="general"
VERSION=0.16
NAME="chrpath"



cd $SOURCE_DIR

URL=https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz

if [ ! -z $URL ]
then
wget -nc https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/chrpath-0.16 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
