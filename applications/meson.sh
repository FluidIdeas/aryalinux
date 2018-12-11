#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=meson
VERSION=0.39.1
DESCRIPTION="Meson is a project to create the best possible next-generation build system."
SOURCE_ONLY=n

#REQ:python3
#REQ:ninja

URL="https://github.com/mesonbuild/meson/archive/0.39.1.tar.gz"
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

cd $SOURCE_DIR

wget -nc $URL

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

sudo python3 setup.py install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
