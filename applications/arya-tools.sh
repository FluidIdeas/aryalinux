#!/bin/bash

set -e
set +h

NAME=arya-tools
VERSION=1.0

. /etc/alps/alps.conf

pushd /tmp

URL=https://bitbucket.org/chandrakantsingh/arya/get/master.tar.bz2

wget $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY
sudo cp -rvf * /
cd /tmp

sudo rm -r $TARBALL
sudo rm -r $DIRECTORY

echo "$NAME=>`date`" | sudo tee -a /etc/alps/installed-list
echo "$NAME=>$VERSION" | sudo tee -a /etc/alps/versions
