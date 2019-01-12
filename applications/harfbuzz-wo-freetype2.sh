#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:glib2
#REQ:icu

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.0.tar.bz2

NAME=harfbuzz-wo-freetype2
VERSION=2.3.0
URL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.0.tar.bz2

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

./configure --prefix=/usr --with-gobject &&
make -j$(nproc)

sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
