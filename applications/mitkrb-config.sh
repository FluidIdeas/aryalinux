#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR


register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
