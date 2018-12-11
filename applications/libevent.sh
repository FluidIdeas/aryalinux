#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libevent is an asynchronous eventbr3ak notification software library. The libevent API provides a mechanism to execute abr3ak callback function when a specific event occurs on a file descriptorbr3ak or after a timeout has been reached. Furthermore, libevent also supports callbacks due tobr3ak signals or regular timeouts.br3ak"
SECTION="basicnet"
VERSION=2.1.8
NAME="libevent"

#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.1.8-stable.tar.gz

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
