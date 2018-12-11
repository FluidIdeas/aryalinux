#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="wine"
VERSION="1.8.3"

cd $SOURCE_DIR

URL="http://dl.winehq.org/wine/source/1.8/wine-1.8.3.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ `uname -m` == "x86_64" ]
then
	FLAG64="--enable-win64"
fi
./configure --prefix=/usr $FLAG64 &&
make "-j`nproc`"
sudo make install

if [ `uname -m` == "x86_64" ]
then
	sudo ln -svf /usr/bin/wine64 /usr/bin/wine
fi

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
