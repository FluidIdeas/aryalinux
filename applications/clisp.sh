#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:libsigsegv

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2
wget -nc ftp://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/clisp-2.49-readline7_fixes-1.patch

NAME=clisp
VERSION=2.49.
URL=https://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2

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

sed -i -e '/socket/d' -e '/"streams"/d' tests/tests.lisp
patch -Np1 -i ../clisp-2.49-readline7_fixes-1.patch
mkdir build &&
cd build &&

../configure --srcdir=../ \
--prefix=/usr \
--docdir=/usr/share/doc/clisp-2.49 \
--with-libsigsegv-prefix=/usr &&

ulimit -s 16384 &&
make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
