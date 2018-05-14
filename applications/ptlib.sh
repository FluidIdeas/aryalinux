#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Ptlib (Portable Tools Library)br3ak package contains a class library that has its genesis many yearsbr3ak ago as PWLib (portable Windows Library), a method to producebr3ak applications to run on various platforms.br3ak"
SECTION="general"
VERSION=2.10.11
NAME="ptlib"

#REC:alsa-lib
#OPT:cyrus-sasl
#OPT:lua
#OPT:openldap
#OPT:pulseaudio
#OPT:sdl
#OPT:unixodbc
#OPT:v4l-utils


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ptlib-2.10.11-bison_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/ptlib/ptlib-2.10.11-bison_fixes-2.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ptlib-2.10.11-openssl-1.1.0-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/ptlib/ptlib-2.10.11-openssl-1.1.0-1.patch

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

sed -i "s/sbin\.Right(1) == '\\\\0')/strlen(sbin\.Right(1)) == 0)/" \
    src/ptclib/podbc.cxx &&
    
sed -i '/\/ioctl.h/a#include <sys/uio.h>' src/ptlib/unix/channel.cxx


patch -Np1 -i ../ptlib-2.10.11-openssl-1.1.0-1.patch &&
patch -Np1 -i ../ptlib-2.10.11-bison_fixes-2.patch &&
./configure --prefix=/usr  \
            --disable-odbc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpt.so.2.10.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
