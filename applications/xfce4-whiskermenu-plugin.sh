#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="The Whisker Menu presents a Windows-Like start menu for XFCE panel"
NAME="xfce4-whiskermenu-plugin"
VERSION="2.1.7"

#REQ:cmake


cd $SOURCE_DIR

URL=https://git.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/snapshot/xfce4-whiskermenu-plugin-2.1.7.tar.gz

wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar -xf $TARBALL

cd $DIRECTORY

mkdir build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..

make

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
