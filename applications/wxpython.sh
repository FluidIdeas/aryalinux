#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="Python bindings for wxWidgets"
NAME="wxpython"
VERSION="latest"

#REQ:wxwidgets

cd $SOURCE_DIR

sudo pip install -U wxPython

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
