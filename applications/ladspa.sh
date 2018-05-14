#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="ladspa-sdk_.orig"
VERSION="1.13"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/l/ladspa-sdk/ladspa-sdk_1.13.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

pushd src
sed -i "s@-mkdirhier@mkdir -pv@g" makefile
make
sudo make install
popd

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
