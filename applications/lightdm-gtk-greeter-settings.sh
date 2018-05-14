#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="lightdm-gtk-greeter-settings"
VERSION="1.2.1"

#REQ:python-distutils-extra

URL=https://launchpad.net/lightdm-gtk-greeter-settings/1.2/1.2.1/+download/lightdm-gtk-greeter-settings-1.2.1.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

python3 setup.py build &&
sudo python3 setup.py install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
