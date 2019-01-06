#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:perl-text-csv_xs
#REC:biber

cd $SOURCE_DIR

wget -nc https://www.cpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-1.99.tar.gz

NAME=text::csv-1.99
VERSION=1.99
URL=https://www.cpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-1.99.tar.gz

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
