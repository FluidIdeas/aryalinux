#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Apache Portable Runtime (APR) is a supporting library for thebr3ak Apache web server. It provides a set of application programmingbr3ak interfaces (APIs) that map to the underlying Operating System (OS).br3ak Where the OS doesn't support a particular function, APR willbr3ak provide an emulation. Thus programmers can use the APR to make abr3ak program portable across different platforms.br3ak"
SECTION="general"
VERSION=1.6.5
NAME="apr"



cd $SOURCE_DIR

URL=https://archive.apache.org/dist/apr/apr-1.6.5.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://archive.apache.org/dist/apr/apr-1.6.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apr/apr-1.6.5.tar.bz2 || wget -nc ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-1.6.5.tar.bz2

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

./configure --prefix=/usr    \
            --disable-static \
            --with-installbuilddir=/usr/share/apr-1/build &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
