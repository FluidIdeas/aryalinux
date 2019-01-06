#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:x7lib
#OPT:libpng
#OPT:libjpeg
#OPT:libtiff
#OPT:giflib

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/enlightenment/imlib2-1.5.1.tar.bz2

NAME=imlib2
VERSION=""
URL=https://downloads.sourceforge.net/enlightenment/imlib2-1.5.1.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m755 -d /usr/share/doc/imlib2-1.5.1 &&
install -v -m644    doc/{*.gif,index.html} \
                    /usr/share/doc/imlib2-1.5.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
