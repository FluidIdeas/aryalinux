#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:alsa-lib
#OPT:cyrus-sasl
#OPT:lua
#OPT:openldap
#OPT:pulseaudio
#OPT:sdl
#OPT:unixodbc
#OPT:v4l-utils

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ptlib-2.10.11-bison_fixes-2.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ptlib-2.10.11-openssl-1.1.0-1.patch

NAME=ptlib
VERSION=2.10.11
URL=http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz

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

sed -i "s/sbin\.Right(1) == '\\\\0')/strlen(sbin\.Right(1)) == 0)/" \
    src/ptclib/podbc.cxx &&
    
sed -i '/\/ioctl.h/a#include <sys/uio.h>' src/ptlib/unix/channel.cxx
patch -Np1 -i ../ptlib-2.10.11-openssl-1.1.0-1.patch &&
patch -Np1 -i ../ptlib-2.10.11-bison_fixes-2.patch &&

./configure --prefix=/usr  \
            --disable-odbc &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
chmod -v 755 /usr/lib/libpt.so.2.10.11
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
