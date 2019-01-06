#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:docbook
#REQ:docbook-xsl
#OPT:fop
#OPT:PassiveTeX
#OPT:links
#OPT:lynx
#OPT:w3m

cd $SOURCE_DIR

wget -nc https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2

NAME=xmlto
VERSION=0.0.28.
URL=https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2

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

LINKS="/usr/bin/links" \
./configure --prefix=/usr &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
