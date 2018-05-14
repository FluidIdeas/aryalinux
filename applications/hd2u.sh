#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The hd2u package contains an anybr3ak to any text format converter.br3ak"
SECTION="general"
VERSION=1.0.4
NAME="hd2u"

#REQ:popt


cd $SOURCE_DIR

URL=http://hany.sk/~hany/_data/hd2u/hd2u-1.0.4.tgz

if [ ! -z $URL ]
then
wget -nc http://hany.sk/~hany/_data/hd2u/hd2u-1.0.4.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hd2u/hd2u-1.0.4.tgz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
