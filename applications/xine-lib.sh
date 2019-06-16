#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:installing
#REQ:ffmpeg
#REQ:alsa
#REQ:pulseaudio
#REQ:libdvdnav


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/xine/xine-lib-1.2.9.tar.xz
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/xine-lib-1.2.9.tar.xz


NAME=xine-lib
VERSION=1.2.9
URL=https://downloads.sourceforge.net/xine/xine-lib-1.2.9.tar.xz

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


sed -e 's|wand/magick_wand.h|MagickWand/MagickWand.h|' \
    -i src/video_dec/image.c &&

sed -e 's/\(xcb-shape >= 1.0\)/xcb \1/' \
    -i m4/video_out.m4 &&

./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.9 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

