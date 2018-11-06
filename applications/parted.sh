#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Parted package is a diskbr3ak partitioning and partition resizing tool.br3ak"
SECTION="postlfs"
VERSION=3.2
NAME="parted"

#REC:lvm2
#OPT:pth
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/parted-3.2-devmapper-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/parted/parted-3.2-devmapper-1.patch

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

patch -Np1 -i ../parted-3.2-devmapper-1.patch


sed -i '/utsname.h/a#include <sys/sysmacros.h>' libparted/arch/linux.c &&
./configure --prefix=/usr --disable-static &&
make &&
make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi


sed -i '/t0251-gpt-unicode.sh/d' tests/Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/parted-3.2/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.2/html &&
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
