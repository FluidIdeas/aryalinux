#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME="sass"
VERSION=
DESCRIPTION=

#REQ:ruby

cd $SOURCE_DIR

sudo gem install sass

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
