#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GDB, the GNU Project debugger,br3ak allows you to see what is going on “<span class=\"quote\">inside” another program while it executes --br3ak or what another program was doing at the moment it crashed. Notebr3ak that GDB is most effective whenbr3ak tracing programs and libraries that were built with debuggingbr3ak symbols and not stripped.br3ak"
SECTION="general"
VERSION=8.2
NAME="gdb"

#OPT:dejagnu
#OPT:doxygen
#OPT:gcc
#OPT:guile
#OPT:python2
#OPT:rust
#OPT:valgrind


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-8.2.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz

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

./configure --prefix=/usr --with-system-readline &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C gdb install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
