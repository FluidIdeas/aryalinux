#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:libsndfile
#OPT:fftw

cd $SOURCE_DIR

wget -nc http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz

NAME=libsamplerate
VERSION=0.1.9
URL=http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz

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
make htmldocdir=/usr/share/doc/libsamplerate-0.1.9 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
