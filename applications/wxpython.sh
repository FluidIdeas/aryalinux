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

sudo pip3 install -U --pre -f https://wxpython.org/Phoenix/snapshot-builds/ wxPython_Phoenix

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
