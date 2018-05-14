#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

SOURCE_ONLY=y
URL=http://www.cpan.org/authors/id/F/FD/FDESAR/Parse-Yapp-1.05.tar.gz
NAME="perl-modules#perl-parse-yapp"
VERSION=1.05

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

perl Makefile.PL
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "perl-modules#perl-parse-yapp=>`date`" | sudo tee -a $INSTALLED_LIST
