#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The JSON-C implements a referencebr3ak counting object model that allows you to easily construct JSONbr3ak objects in C, output them as JSON formatted strings and parse JSONbr3ak formatted strings back into the C representation of JSON objects.br3ak"
SECTION="general"
VERSION=0.13.1
NAME="json-c"



cd $SOURCE_DIR

URL=https://s3.amazonaws.com/json-c_releases/releases/json-c-0.13.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://s3.amazonaws.com/json-c_releases/releases/json-c-0.13.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.13.1.tar.gz

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
