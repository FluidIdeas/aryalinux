#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="tlp"
VERSION="`date`"

cd $SOURCE_DIR

wget https://github.com/linrunner/TLP/archive/master.zip -O tlp.zip
unzip tlp.zip

cd TLP-master

make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf TLP-master

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
