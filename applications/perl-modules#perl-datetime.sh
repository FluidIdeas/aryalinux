#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#cpan-meta-check
#REQ:perl-modules#perl-module-implementation
#REQ:perl-modules#perl-test-needs
#REQ:perl-modules#params-validationcompiler
#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-try-tiny

SOURCE_ONLY=y
URL="http://search.cpan.org//CPAN/authors/id/D/DR/DROLSKY/DateTime-1.48.tar.gz"
VERSION=1.48
NAME="perl-modules#perl-datetime"

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

register_installed "$NAME=>`date`" "$VERSION" "$INSTALLED_LIST"
