#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:bind
#OPT:bind-utils
#OPT:boost
#OPT:gdb
#OPT:llvm
#OPT:which

cd $SOURCE_DIR

wget -nc https://sourceware.org/ftp/valgrind/valgrind-3.14.0.tar.bz2
wget -nc ftp://sourceware.org/pub/valgrind/valgrind-3.14.0.tar.bz2

NAME=valgrind
VERSION=3.14.0
URL=https://sourceware.org/ftp/valgrind/valgrind-3.14.0.tar.bz2

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

sed -i 's|/doc/valgrind||' docs/Makefile.in &&

./configure --prefix=/usr \
--datadir=/usr/share/doc/valgrind-3.14.0 &&
make
sed -e 's@prereq:.*@prereq: false@' \
-i {helgrind,drd}/tests/pth_cond_destroy_busy.vgtest

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
