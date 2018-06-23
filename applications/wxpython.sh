#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

URL=https://wxpython.org/Phoenix/snapshot-builds/wxPython-4.0.2a1.dev3806+d0516bfa.tar.gz
DESCRIPTION="Python bindings for wxWidgets"
NAME="wxpython"
VERSION="4.0.2a1.dev3806+d0516bfa"

#REQ:wxwidgets

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY
python3 setup.py build
sudo python3 setup.py install


cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
