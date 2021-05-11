#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:aspell


cd $SOURCE_DIR

wget -nc https://github.com/AbiWord/enchant/releases/download/v2.2.15/enchant-2.2.15.tar.gz


NAME=enchant
VERSION=2.2.15
URL=https://github.com/AbiWord/enchant/releases/download/v2.2.15/enchant-2.2.15.tar.gz
SECTION="General Libraries"
DESCRIPTION="The enchant package provide a generic interface into various existing spell checking libraries."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


./configure --prefix=/usr --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > /tmp/test-enchant.txt << "EOF"
Tel me more abot linux
Ther ar so many commads
EOF

enchant-2 -d en_GB -l /tmp/test-enchant.txt &&
enchant-2 -d en_GB -a /tmp/test-enchant.txt


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

