#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:libsndfile
#OPT:nasm

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lame/lame-3.100.tar.gz

NAME=lame
VERSION=3.100
URL=https://downloads.sourceforge.net/lame/lame-3.100.tar.gz

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

case $(uname -m) in
i?86) sed -i -e 's/<xmmintrin.h/&.nouse/' configure ;;
esac
./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make pkghtmldir=/usr/share/doc/lame-3.100 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
