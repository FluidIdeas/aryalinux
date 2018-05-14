#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.br3ak"
SECTION="general"
VERSION=9.11.1
NAME="nodejs"

#REQ:python2
#REC:c-ares
#REC:icu


cd $SOURCE_DIR

URL=https://nodejs.org/dist/v9.11.1/node-v9.11.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://nodejs.org/dist/v9.11.1/node-v9.11.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/node/node-v9.11.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/node/node-v9.11.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/node/node-v9.11.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/node/node-v9.11.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/node/node-v9.11.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/node/node-v9.11.1.tar.xz

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

./configure --prefix=/usr                  \
            --shared-cares                 \
            --shared-openssl               \
            --shared-zlib                  \
            --with-intl=system-icu         &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sf node /usr/share/doc/node-9.11.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
