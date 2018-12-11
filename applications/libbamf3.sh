#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="libbamf3"
DESCRIPTION="bamf Removes the headache of applications matching into a simple DBus daemon and c wrapper library."
VERSION="0.5.3"

#REQ:libwnck
#REQ:libgtop
#REQ:python-modules#libxml2py2
#REQ:libxslt

cd $SOURCE_DIR

URL=https://launchpad.net/bamf/0.5/0.5.3/+download/bamf-0.5.3.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

CFLAGS="-Wno-error=deprecated-declarations" ./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
