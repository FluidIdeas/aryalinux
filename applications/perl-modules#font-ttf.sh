#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

SOURCE_ONLY=y
URL=http://search.cpan.org/CPAN/authors/id/B/BH/BHALLISSY/Font-TTF-1.06.tar.gz
NAME="perl-modules#font-ttf"
VERSION=1.06

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

echo "perl-modules#font-ttf=>`date`" | sudo tee -a $INSTALLED_LIST
