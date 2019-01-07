#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:x7lib
#REC:hicolor-icon-theme
#REC:libjpeg
#OPT:alsa-lib
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:glu
#OPT:mesa
#OPT:texlive

cd $SOURCE_DIR

wget -nc http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz

NAME=fltk
VERSION=1.3.4-2-source
URL=http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-2-source.tar.gz

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

sed -i -e '/cat./d' documentation/Makefile &&

./configure --prefix=/usr \
--enable-shared &&
make
make -C documentation html

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/fltk-1.3.4-2 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C test docdir=/usr/share/doc/fltk-1.3.4-2 install-linux &&
make -C documentation docdir=/usr/share/doc/fltk-1.3.4-2 install-linux
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
