#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-class-factory-util
#REQ:perl-datetime-format-strptime
#REQ:perl-params-validate

cd $SOURCE_DIR

wget -nc https://www.cpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.81.tar.gz

NAME=datetime::format::builder-0.81
VERSION=0.81
URL=https://www.cpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.81.tar.gz

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
