#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="cython"
VERSION="0.24"

cd $SOURCE_DIR

URL="https://pypi.python.org/packages/b1/51/bd5ef7dff3ae02a2c6047aa18d3d06df2fb8a40b00e938e7ea2f75544cac/Cython-0.24.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sudo python setup.py install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
