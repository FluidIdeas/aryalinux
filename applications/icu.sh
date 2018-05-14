#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The International Components forbr3ak Unicode (ICU) package is a mature, widely used set of C/C++br3ak libraries providing Unicode and Globalization support for softwarebr3ak applications. ICU is widelybr3ak portable and gives applications the same results on all platforms.br3ak"
SECTION="general"
VERSION=61_1
NAME="icu"

#OPT:llvm
#OPT:doxygen


cd $SOURCE_DIR

URL=http://download.icu-project.org/files/icu4c/61.1/icu4c-61_1-src.tgz

if [ ! -z $URL ]
then
wget -nc http://download.icu-project.org/files/icu4c/61.1/icu4c-61_1-src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icu/icu4c-61_1-src.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/icu/icu4c-61_1-src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-61_1-src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-61_1-src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-61_1-src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-61_1-src.tgz

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

cd source                                    &&
./configure --prefix=/usr                    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
