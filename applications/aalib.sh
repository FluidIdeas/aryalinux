#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=aalib
VERSION=1.4rc5
URL=https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz


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

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4
sed -e 's/8x13bold/-*-luxi mono-bold-r-normal--13-120-*-*-m-*-*-*/' \
    -i src/aax.c
sed 's/stdscr->_max\([xy]\) + 1/getmax\1(stdscr)/' \
    -i src/aacurses.c
sed -i '1i#include <stdlib.h>'                            \
    src/aa{fire,info,lib,linuxkbd,savefont,test,regist}.c
sed -i '1i#include <string.h>'                            \
    src/aa{kbdreg,moureg,test,regist}.c
sed -i '/X11_KBDDRIVER/a#include <X11/Xutil.h>'           \
    src/aaxkbd.c
sed -i '/rawmode_init/,/^}/s/return;/return 0;/'          \
    src/aalinuxkbd.c
autoconf
./configure --prefix=/usr             \
            --infodir=/usr/share/info \
            --mandir=/usr/share/man   \
            --with-ncurses=/usr       \
            --disable-static
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

popd