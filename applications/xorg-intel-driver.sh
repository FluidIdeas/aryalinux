#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xcb-util
#REQ:xorg-server


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20190208.tar.xz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20190208.tar.xz


NAME=xorg-intel-driver
VERSION=20190208
URL=http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20190208.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

sed -i "s/#define force_inline inline __attribute__((always_inline))/#define force_inline inline/" src/sna/compiler.h
./autogen.sh $XORG_CONFIG     \
            --enable-kms-only \
            --enable-uxa      \
            --mandir=/usr/share/man &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
      
mv -v /usr/share/man/man4/intel-virtual-output.4 \
      /usr/share/man/man1/intel-virtual-output.1 &&
      
sed -i '/\.TH/s/4/1/' /usr/share/man/man1/intel-virtual-output.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

