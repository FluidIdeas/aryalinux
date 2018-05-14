#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The HarfBuzz package contains anbr3ak OpenType text shaping engine.br3ak"
SECTION="general"
VERSION=1.7.6
NAME="harfbuzz"

#REC:glib2
#REC:icu
#REC:freetype2-without-harfbuzz
#REC:graphite2
#OPT:cairo
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:texlive
#OPT:libreoffice


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.7.6.tar.bz2

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

./configure --prefix=/usr --with-graphite2=yes --with-gobject &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
