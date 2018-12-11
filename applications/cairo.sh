#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libpng
#REQ:pixman
#REC:fontconfig
#REC:glib2
#REC:x7lib
#OPT:cogl
#OPT:gs
#OPT:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:libdrm
#OPT:librsvg
#OPT:lzo
#OPT:mesa
#OPT:poppler
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://www.cairographics.org/releases/cairo-1.16.0.tar.xz

NAME=cairo
VERSION=1.16.0
URL=https://www.cairographics.org/releases/cairo-1.16.0.tar.xz

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

./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
