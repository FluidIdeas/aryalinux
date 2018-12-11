#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

wget http://prdownloads.sourceforge.net/jack-rack/jack-rack-1.4.7.tar.bz2?download -O jack-rack-1.4.7.tar.bz2
TARBALL=jack-rack-1.4.7.tar.bz2
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  --includedir=/usr/include
sed -i "s@JACK_LIBS = -ljack@JACK_LIBS = -ljack -lpthread -ldl -lm@g" src/Makefile
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
