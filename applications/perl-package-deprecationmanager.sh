#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-package-stash
#REQ:perl-sub-install
#REC:perl-test-fatal
#REC:perl-test-warnings

cd $SOURCE_DIR

wget -nc https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.17.tar.gz

NAME=package::deprecationmanager-0.17
VERSION=0.17
URL=https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.17.tar.gz

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
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
