#!/bin/bash

set -e
set +e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=nodejs6
VERSION=6.9.1
URL=https://nodejs.org/dist/v6.9.1/node-v6.9.1.tar.gz

cd $SOURCE_DIR

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

sudo tar xf $TARBALL -C /opt
sudo ln -svf /opt/$DIRECTORY/bin/* /usr/bin

cd $SOURCE_DIR
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

