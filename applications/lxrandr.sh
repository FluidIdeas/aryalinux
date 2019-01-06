#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:x7app
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxde/lxrandr-0.3.1.tar.xz

NAME=lxrandr
VERSION=0.3.1
URL=https://downloads.sourceforge.net/lxde/lxrandr-0.3.1.tar.xz

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
