#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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

wget -nc https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz

NAME=fontforge
VERSION=20170731
URL=https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--enable-gtk2-use \
--disable-static \
--docdir=/usr/share/doc/fontforge-20170731 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
