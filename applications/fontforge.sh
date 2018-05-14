#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The FontForge package contains anbr3ak outline font editor that lets you create your own postscript,br3ak truetype, opentype, cid-keyed, multi-master, cff, svg and bitmapbr3ak (bdf, FON, NFNT) fonts, or edit existing ones.br3ak"
SECTION="xsoft"
VERSION=20170731
NAME="fontforge"

#REQ:freetype2
#REQ:glib2
#REQ:libxml2
#REC:cairo
#REC:gtk2
#REC:harfbuzz
#REC:pango
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:x7lib
#OPT:giflib
#OPT:libjpeg
#OPT:libpng
#OPT:libtiff
#OPT:python2
#OPT:wget


cd $SOURCE_DIR

URL=https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20170731.tar.xz

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

./configure --prefix=/usr     \
            --enable-gtk2-use \
            --disable-static  \
            --docdir=/usr/share/doc/fontforge-20170731 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
