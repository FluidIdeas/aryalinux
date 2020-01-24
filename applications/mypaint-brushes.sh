#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libmypaint


cd $SOURCE_DIR

wget -nc https://github.com/Jehan/mypaint-brushes/archive/v1.3.0/mypaint-brushes-v1.3.0.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/mypaint-brushes-1.3.0-automake_1.16-1.patch


NAME=mypaint-brushes
VERSION=1.3.0
URL=https://github.com/Jehan/mypaint-brushes/archive/v1.3.0/mypaint-brushes-v1.3.0.tar.gz
SECTION="General Libraries and Utilities"
DESCRIPTION="The mypaint-brushes package contains brushes used by packages which use libmypaint."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


patch -Np1 -i ../mypaint-brushes-1.3.0-automake_1.16-1.patch &&
./autogen.sh                                                 &&
./configure --prefix=/usr                                    &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

