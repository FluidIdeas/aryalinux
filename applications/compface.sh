#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Compface provides utilities and abr3ak library to convert from/to X-Face format, a 48x48 bitmap formatbr3ak used to carry thumbnails of email authors in a mail header.br3ak"
SECTION="general"
VERSION=1.5.2
NAME="compface"



cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz

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

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -m755 -v xbm2xface.pl /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
