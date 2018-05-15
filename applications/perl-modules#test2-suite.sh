#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#importer
#REQ:perl-modules#test-simple
#REQ:perl-modules#sub-info
#REQ:perl-modules#term-table
#REQ:perl-modules#module-pluggable
#REQ:perl-modules#scope-guard

SOURCE_ONLY=y
URL="http://search.cpan.org/CPAN/authors/id/E/EX/EXODIST/Test2-Suite-0.000114.tar.gz"
VERSION=0.000114
NAME="perl-modules#test2-suite"

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

