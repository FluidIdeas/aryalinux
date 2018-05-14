#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The FreeType2 package contains abr3ak library which allows applications to properly render TrueType fonts.br3ak"
SECTION="general"
VERSION=2.9
NAME="freetype2"

#REC:harfbuzz
#REC:libpng
#REC:general_which


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-2.9.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetype/freetype-2.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.9.tar.bz2
wget -nc https://downloads.sourceforge.net/freetype/freetype-doc-2.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.9.tar.bz2

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

tar -xf ../freetype-doc-2.9.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/freetype-2.9 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.9

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../freetype-doc-2.9.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/freetype-2.9 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.9

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
