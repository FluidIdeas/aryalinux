#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="Python bindings for wxWidgets"
NAME="wxpython"
VERSION="latest"

#REQ:wxwidgets

sudo pip install -U wxPython

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
