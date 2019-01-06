#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-business-isbn-data

cd $SOURCE_DIR

wget -nc https://www.cpan.org/authors/id/B/BD/BDFOY/Business-ISBN-3.004.tar.gz

NAME=business::isbn-3.004
VERSION=3.004
URL=https://www.cpan.org/authors/id/B/BD/BDFOY/Business-ISBN-3.004.tar.gz

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
make             &&
make test

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
