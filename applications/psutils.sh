#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz


NAME=psutils
VERSION=17
URL=http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz
SECTION="Printing and Typesetting"
DESCRIPTION="PSUtils is a set of utilities to manipulate PostScript files."

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


sed 's@/usr/local@/usr@g' Makefile.unix > Makefile &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

lp -o number-up=2 <filename>


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

