#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-lwp
#REQ:perl-modules#io-socket-ssl
#REQ:perl-modules#mozilla-ca

SOURCE_ONLY=y
URL="https://www.cpan.org/authors/id/M/MS/MSCHILLI/LWP-Protocol-https-6.06.tar.gz"
VERSION=6.06
NAME="perl-modules#perl-lwp-protocol-https"

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
