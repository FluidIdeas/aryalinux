#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:dejagnu
#OPT:doxygen
#OPT:gcc
#OPT:guile
#OPT:python2
#OPT:rust
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz

NAME=gdb
VERSION=8.2.1
URL=https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz

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

./configure --prefix=/usr --with-system-readline &&
make
make -C gdb/doc doxy
pushd gdb/testsuite &&
make site.exp &&
echo "set gdb_test_timeout 120" >> site.exp &&
runtest
popd

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C gdb install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -d /usr/share/doc/gdb-8.2.1 &&
rm -rf gdb/doc/doxy/xml &&
cp -Rv gdb/doc/doxy /usr/share/doc/gdb-8.2.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
