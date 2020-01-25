#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:pango


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz


NAME=paps
VERSION=0.6.8
URL=https://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz
SECTION="PostScript"
DESCRIPTION="paps is a text to PostScript converter that works through Pango. Its input is a UTF-8 encoded text file and it outputs vectorized PostScript. It may be used for printing any complex script supported by Pango."

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


./configure --prefix=/usr --mandir=/usr/share/man &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d                 /usr/share/doc/paps-0.6.8 &&
install -v -m644 doxygen-doc/html/* /usr/share/doc/paps-0.6.8
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

