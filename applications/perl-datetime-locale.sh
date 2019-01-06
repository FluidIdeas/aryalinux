#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-dist-checkconflicts
#REQ:perl-file-sharedir
#REQ:perl-params-validationcompiler
#REC:perl-cpan-meta-check
#REC:perl-ipc-system-simple
#REC:perl-test-file-sharedir
#REC:perl-test-warnings

cd $SOURCE_DIR

wget -nc https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.23.tar.gz

NAME=
VERSION=1.23
URL=https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.23.tar.gz

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
