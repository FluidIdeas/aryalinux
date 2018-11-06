#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak SassC is a wrapper around libsass, a CSS pre-processor language.br3ak"
SECTION="gnome"
VERSION=3.5.0
NAME="sassc"



cd $SOURCE_DIR

URL=https://github.com/sass/sassc/archive/3.5.0/sassc-3.5.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/sass/sassc/archive/3.5.0/sassc-3.5.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sassc/sassc-3.5.0.tar.gz
wget -nc https://github.com/sass/libsass/archive/3.5.4/libsass-3.5.4.tar.gz

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

autoreconf -fi &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../sassc-3.5.0.tar.gz &&
cd sassc-3.5.0 &&
autoreconf -fi &&
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
