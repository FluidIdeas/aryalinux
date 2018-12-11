#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="tbb44_20160526oss_src"
VERSION="_0"

URL=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160526oss_src_0.tgz

cd /opt/

sudo wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

sudo tar -xf $TARBALL
cd $DIRECTORY

sudo make

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
