#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Valgrind is an instrumentationbr3ak framework for building dynamic analysis tools. There are Valgrindbr3ak tools that can automatically detect many memory management andbr3ak threading bugs, and profile programs in detail. Valgrind can alsobr3ak be used to build new tools.br3ak"
SECTION="general"
VERSION=3.13.0
NAME="valgrind"

#OPT:bind
#OPT:bind-utils
#OPT:boost
#OPT:gdb
#OPT:llvm
#OPT:general_which


cd $SOURCE_DIR

URL=https://sourceware.org/ftp/valgrind/valgrind-3.13.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/ftp/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.13.0.tar.bz2 || wget -nc ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2

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

sed -i '1904s/4/5/' coregrind/m_syswrap/syswrap-linux.c


sed -i 's|/doc/valgrind||' docs/Makefile.in &&
./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.13.0 &&
make "-j`nproc`" || make


sed -e 's@prereq:.*@prereq: false@' \
    -i {helgrind,drd}/tests/pth_cond_destroy_busy.vgtest



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
