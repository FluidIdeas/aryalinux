#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="openshot_.orig"
VERSION="1.4.3"

#REQ:setuptools
#REQ:ladspa
#REQ:fontconfig
#REQ:gtk2
#REQ:librsvg
#REQ:melt
#REQ:pillow
#REQ:pygoocanvas
#REQ:python-modules#pyxdg
#REQ:frei0r-plugins

URL=http://archive.ubuntu.com/ubuntu/pool/universe/o/openshot/openshot_1.4.3.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
