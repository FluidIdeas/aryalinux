#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:python2

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz

NAME=asciidoc
VERSION=8.6.9
URL=https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/asciidoc-8.6.9 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
make docs
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
