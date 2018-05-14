#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The librep package contains a Lispbr3ak system. This is useful for scripting or for applications that maybr3ak use the Lisp interpreter as an extension language.br3ak"
SECTION="general"
VERSION=0.92.7
NAME="librep"



cd $SOURCE_DIR

URL=http://download.tuxfamily.org/librep/librep_0.92.7.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.tuxfamily.org/librep/librep_0.92.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/librep/librep_0.92.7.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/librep/librep_0.92.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/librep/librep_0.92.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/librep/librep_0.92.7.tar.xz

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
