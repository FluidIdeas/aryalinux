#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xmlto


cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/giflib/files/giflib-5.1.9.tar.gz


NAME=giflib
VERSION=5.1.9
URL=https://sourceforge.net/projects/giflib/files/giflib-5.1.9.tar.gz

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


make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install &&
rm -vf /usr/lib/libgif.a &&

find doc \( -name Makefile\* -o -name \*.1 \
         -o -name \*.xml \) -exec rm -v {} \; &&

install -v -dm755 /usr/share/doc/giflib-5.1.9 &&
cp -v -R doc/* /usr/share/doc/giflib-5.1.9
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

