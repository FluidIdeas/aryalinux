#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python-modules#six


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz


NAME=gdb
VERSION=8.3
URL=https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz
SECTION="Programming"
DESCRIPTION="GDB, the GNU Project debugger, allows you to see what is going on “inside” another program while it executes -- or what another program was doing at the moment it crashed. Note that GDB is most effective when tracing programs and libraries that were built with debugging symbols and not stripped."

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


./configure --prefix=/usr \
            --with-system-readline \
            --with-python=/usr/bin/python3 &&
make
make -C gdb/doc doxy
pushd gdb/testsuite &&
make  site.exp      &&
echo  "set gdb_test_timeout 120" >> site.exp &&
runtest
popd
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C gdb install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -d /usr/share/doc/gdb-8.3 &&
rm -rf gdb/doc/doxy/xml &&
cp -Rv gdb/doc/doxy /usr/share/doc/gdb-8.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

