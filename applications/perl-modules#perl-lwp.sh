#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#encode-locale
#REQ:perl-modules#perl-uri
#REQ:perl-modules#http-cookies
#REQ:perl-modules#http-negotiate
#REQ:perl-modules#net-http
#REQ:perl-modules#www-robotrules
#REQ:perl-modules#http-daemon
#REQ:perl-modules#file-listing
#REQ:perl-modules#test-requiresinternet
#REQ:perl-modules#perl-test-fatal

SOURCE_ONLY=y
URL="https://www.cpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.33.tar.gz"
VERSION=6.33
NAME="perl-modules#perl-lwp"

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
