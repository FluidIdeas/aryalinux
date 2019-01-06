#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-module-build
#REQ:perl-super
#REC:perl-test-warnings

cd $SOURCE_DIR

wget -nc https://cpan.metacpan.org/authors/id/G/GF/GFRANKS/Test-MockModule-v0.170.0.tar.gz

NAME=test::mockmodule-v0.170.0
VERSION=v0.170.0
URL=https://cpan.metacpan.org/authors/id/G/GF/GFRANKS/Test-MockModule-v0.170.0.tar.gz

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

perl Build.PL &&
./Build       &&
./Build test

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
./Build install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
