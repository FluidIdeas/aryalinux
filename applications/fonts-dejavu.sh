#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="fonts-dejavu_.orig"
VERSION="2.35"

#REQ:fontforge
#REQ:perl-modules#font-ttf
#REQ:perl-modules#io-string

URL=http://archive.ubuntu.com/ubuntu/pool/main/f/fonts-dejavu/fonts-dejavu_2.35.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

make full-ttf
sudo mkdir -pv /usr/share/fonts/truetype/dejavu/
sudo cp -v build/*.ttf /usr/share/fonts/truetype/dejavu/

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
