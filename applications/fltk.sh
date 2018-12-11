#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:x7lib
#REC:hicolor-icon-theme
#REC:libjpeg
#REC:libpng
#OPT:alsa-lib
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:glu
#OPT:mesa
#OPT:texlive
#OPT:tl-installer

cd $SOURCE_DIR

wget -nc http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz

URL=http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz

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

sed -i -e '/cat./d' documentation/Makefile       &&

./configure --prefix=/usr    \
            --enable-shared  &&
make
make -C documentation html

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make docdir=/usr/share/doc/fltk-1.3.4 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C test          docdir=/usr/share/doc/fltk-1.3.4 install-linux &&
make -C documentation docdir=/usr/share/doc/fltk-1.3.4 install-linux
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
