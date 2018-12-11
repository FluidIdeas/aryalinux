#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The CDParanoia package contains abr3ak CD audio extraction tool. This is useful for extractingbr3ak <code class=\"filename\">.wav files from audio CDs. A CDDAbr3ak capable CDROM drive is needed. Practically all drives supported bybr3ak Linux can be used.br3ak"
SECTION="multimedia"
VERSION=10.2
NAME="cdparanoia"



cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/cdparanoia-III-10.2-gcc_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/cdparanoia/cdparanoia-III-10.2-gcc_fixes-1.patch

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

patch -Np1 -i ../cdparanoia-III-10.2-gcc_fixes-1.patch &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libcdda_*.so.0.10.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
