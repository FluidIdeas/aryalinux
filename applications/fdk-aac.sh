#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak fdk-aac package provides thebr3ak Fraunhofer FDK AAC library, which is purported to be a high qualitybr3ak Advanced Audio Coding implementation.br3ak"
SECTION="multimedia"
VERSION=0.1.6
NAME="fdk-aac"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.6.tar.gz

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
