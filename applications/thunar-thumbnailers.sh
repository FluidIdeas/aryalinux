#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:thunar
#REQ:xfce4-dev-tools

NAME=thunar-thumbnailers
VERSION=0.4.1
DESCRIPTION="Thunar uses external utilities - so called thumbnailers - to generate previews of certain files. Thunar ships with thumbnailers to generate previews of image and font files and can automatically use available GNOME thumbnailers if it was build with support for gconf."
URL=https://git.xfce.org/apps/thunar-thumbnailers/snapshot/thunar-thumbnailers-0.4.1.tar.bz2

cd $SOURCE_DIR
wget $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
make "-j$(nproc)" || make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

