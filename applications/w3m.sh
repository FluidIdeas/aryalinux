#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gc
#OPT:gpm
#OPT:imlib2
#OPT:gtk2
#OPT:gdk-pixbuf
#OPT:compface

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/w3m-0.5.3-bdwgc72-1.patch

NAME=w3m
VERSION=0.5.3
URL=https://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz

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

patch -Np1 -i ../w3m-0.5.3-bdwgc72-1.patch &&
sed -i 's/file_handle/file_foo/' istream.{c,h} &&
sed -i 's#gdk-pixbuf-xlib-2.0#& x11#' configure &&
sed -i '/USE_EGD/s/define/undef/' config.h.in &&


./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/keymap.default /etc/w3m/keymap &&
install -v -m644 doc/menu.default /etc/w3m/menu &&
install -v -m755 -d /usr/share/doc/w3m-0.5.3 &&
install -v -m644 doc/{HISTORY,READ*,keymap.*,menu.*,*.html} \
/usr/share/doc/w3m-0.5.3
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
