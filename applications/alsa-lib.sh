#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:doxygen
#OPT:python2

cd $SOURCE_DIR

wget -nc ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.7.tar.bz2

NAME=alsa-lib
VERSION=1.1.7.
URL=ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.7.tar.bz2

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

./configure &&
make
make doc

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/doc/alsa-lib-1.1.7/html/search &&
install -v -m644 doc/doxygen/html/*.* \
/usr/share/doc/alsa-lib-1.1.7/html &&
install -v -m644 doc/doxygen/html/search/* \
/usr/share/doc/alsa-lib-1.1.7/html/search
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
