#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:audio-video-plugins
#REQ:libtdb
#REQ:gtk-doc
#REQ:yelp
#REQ:libmtp
#REQ:libimobiledevice
#REQ:libgpod

NAME=rhythmbox
VERSION=3.4.2
DESCRIPTION="Rhythmbox is a music manager and player for gnome desktop environment"

cd $SOURCE_DIR

URL="https://download.gnome.org/sources/rhythmbox/3.4/rhythmbox-3.4.2.tar.xz"
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-mtp --with-ipod &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
