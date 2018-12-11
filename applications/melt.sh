#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="mlt"
VERSION="6.0.0"

#REQ:swig
#REQ:jackd2
#REQ:jackrack

URL=http://downloads.sourceforge.net/mlt/mlt-6.0.0.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --without-kde --prefix=/usr --swig-languages="python" &&
make "-j`nproc`"
sudo make install
pushd src/swig/python
sudo cp -v mlt.py /usr/lib/python2.7/site-packages/
sudo cp -v _mlt.so /usr/lib/python2.7/site-packages/
sudo cp -v mlt_wrap.o /usr/lib/python2.7/site-packages/
popd

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
