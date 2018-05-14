#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tidy HTML5 package contains abr3ak command line tool and libraries used to read HTML, XHTML and XMLbr3ak files and write cleaned up markup. It detects and corrects manybr3ak common coding errors and strives to produce visually equivalentbr3ak markup that is both W3C compliant and compatible with mostbr3ak browsers.br3ak"
SECTION="general"
VERSION=5.4.0
NAME="tidy-html5"

#REQ:cmake
#REC:libxslt


cd $SOURCE_DIR

URL=https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-html5-5.4.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-html5-5.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tidy/tidy-html5-5.4.0.tar.gz

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

cd build/cmake &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TAB2SPACE=ON        \
      ../..    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 tab2space /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
