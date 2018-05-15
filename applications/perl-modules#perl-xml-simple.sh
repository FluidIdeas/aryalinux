#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-xml-sax
#REQ:perl-modules#xml-sax-expat
#REQ:perl-modules#perl-xml-libxml
#REQ:perl-modules#tie-ixhash

SOURCE_ONLY=y
URL="https://www.cpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz"
VERSION=2.25
NAME="perl-modules#perl-xml-simple"

cd $SOURCE_DIR
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ -f Build.PL ]
then
perl Build.PL &&
./Build &&
sudo ./Build install
fi

if [ -f Makefile.PL ]
then
perl Makefile.PL &&
make &&
sudo make install
fi
cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
