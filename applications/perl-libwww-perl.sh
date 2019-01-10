#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-file-listing
#REQ:perl-http-cookies
#REQ:perl-http-daemon
#REQ:perl-http-negotiate
#REQ:perl-net-http
#REQ:perl-try-tiny
#REQ:perl-www-robotrules
#REC:perl-test-fatal
#REC:perl-test-needs
#REC:perl-test-requiresinternet

cd $SOURCE_DIR

wget -nc https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.36.tar.gz

NAME=perl-libwww-perl
VERSION=6.36
URL=https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.36.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

perl Makefile.PL &&
make &&
make test

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"