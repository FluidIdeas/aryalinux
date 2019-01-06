#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2

NAME=cdrtools
VERSION=3.02a09.
URL=https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2

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

export GMAKE_NOWARN=true &&
make -j1 INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
export GMAKE_NOWARN=true &&
make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root install &&
install -v -m755 -d /usr/share/doc/cdrtools-3.02a09 &&
install -v -m644 README* ABOUT doc/*.ps \
/usr/share/doc/cdrtools-3.02a09
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
