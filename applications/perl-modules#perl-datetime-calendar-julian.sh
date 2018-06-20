#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-datetime

SOURCE_ONLY=y
URL="https://www.cpan.org/authors/id/P/PI/PIJLL/DateTime-Calendar-Julian-0.04.tar.gz"
VERSION=0.04
NAME="perl-modules#perl-datetime-calendar-julian"

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
