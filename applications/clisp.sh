#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GNU Clisp is a Common Lispbr3ak implementation which includes an interpreter, compiler, debugger,br3ak and many extensions.br3ak"
SECTION="general"
VERSION=2.49
NAME="clisp"

#REC:libsigsegv


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.gnu.org/gnu/clisp/latest/clisp-2.49.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/clisp-2.49-readline7_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/clisp/clisp-2.49-readline7_fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i -e '/socket/d' -e '/"streams"/d' tests/tests.lisp


patch -Np1 -i ../clisp-2.49-readline7_fixes-1.patch


mkdir build &&
cd    build &&
../configure --srcdir=../                       \
             --prefix=/usr                      \
             --docdir=/usr/share/doc/clisp-2.49 \
             --with-libsigsegv-prefix=/usr &&
ulimit -s 16384 &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
