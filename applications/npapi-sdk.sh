#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak NPAPI-SDK is a bundle of Netscapebr3ak Plugin Application Programming Interface headers by Mozilla. Thisbr3ak package provides a clear way to install those headers and depend onbr3ak them.br3ak"
SECTION="general"
VERSION=0.27.2
NAME="npapi-sdk"



cd $SOURCE_DIR

URL=https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2

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

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
