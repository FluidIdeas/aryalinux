#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#exception-class
#REQ:perl-modules#test2-plugin-nowarnings
#REQ:perl-modules#test-without-module

SOURCE_ONLY=y
URL="https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.30.tar.gz"
VERSION=0.30
NAME="perl-modules#params-validationcompiler"

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

