#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The NPth package contains a verybr3ak portable POSIX/ANSI-C based library for Unix platforms whichbr3ak provides non-preemptive priority-based scheduling for multiplebr3ak threads of execution (multithreading) inside event-drivenbr3ak applications. All threads run in the same address space of thebr3ak server application, but each thread has its own individualbr3ak program-counter, run-time stack, signal mask and errno variable.br3ak"
SECTION="general"
VERSION=1.5
NAME="npth"



cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npth/npth-1.5.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/npth/npth-1.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.5.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
