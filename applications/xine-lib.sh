#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Xine Libraries packagebr3ak contains xine libraries. These are useful for interfacing withbr3ak external plug-ins that allow the flow of information from thebr3ak source to the audio and video hardware.br3ak"
SECTION="multimedia"
VERSION=1.2.8
NAME="xine-lib"

#REQ:ffmpeg
#REQ:pulseaudio
#REQ:xorg-server
#REC:libdvdnav
#OPT:aalib
#OPT:faad2
#OPT:flac
#OPT:gdk-pixbuf
#OPT:glu
#OPT:imagemagick
#OPT:liba52
#OPT:libmad
#OPT:libmng
#OPT:libtheora
#OPT:x7driver
#OPT:libvorbis
#OPT:libvpx
#OPT:mesa
#OPT:samba
#OPT:sdl
#OPT:speex
#OPT:doxygen
#OPT:v4l-utils


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/xine/xine-lib-1.2.8.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/xine/xine-lib-1.2.8.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.8.tar.xz || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xine-lib-1.2.8.tar.xz

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

sed -e 's|wand/magick_wand.h|MagickWand/MagickWand.h|' \
    -i src/video_dec/image.c &&
sed -e 's/\(xcb-shape >= 1.0\)/xcb \1/' \
    -i m4/video_out.m4 &&
./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.8 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
