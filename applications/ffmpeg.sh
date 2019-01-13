#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:libass
#REC:fdk-aac
#REC:freetype2
#REC:lame
#REC:libtheora
#REC:libvorbis
#REC:libvpx
#REC:opus
#REC:x264
#REC:x265
#REC:yasm
#REC:alsa-lib
#REC:libva
#REC:libvdpau
#REC:sdl2
#OPT:fontconfig
#OPT:frei0r
#OPT:libcdio
#OPT:libwebp
#OPT:opencv
#OPT:openjpeg2
#OPT:gnutls
#OPT:pulseaudio
#OPT:speex
#OPT:texlive
#OPT:tl-installer
#OPT:v4l-utils
#OPT:xvid
#OPT:libbluray
#OPT:libdca

cd $SOURCE_DIR

wget -nc http://ffmpeg.org/releases/ffmpeg-4.1.tar.xz

NAME=ffmpeg
VERSION=4.1
URL=http://ffmpeg.org/releases/ffmpeg-4.1.tar.xz

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

sed -i 's/-lflite"/-lflite -lasound"/' configure &&

./configure --prefix=/usr \
--enable-gpl \
--enable-version3 \
--enable-nonfree \
--disable-static \
--enable-shared \
--disable-debug \
--enable-avresample \
--enable-libass \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libmp3lame \
--enable-libopus \
--enable-libtheora \
--enable-libvorbis \
--enable-libvpx \
--enable-libx264 \
--enable-libx265 \
--docdir=/usr/share/doc/ffmpeg-4.1 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 tools/qt-faststart /usr/bin &&
install -v -m755 -d /usr/share/doc/ffmpeg-4.1 &&
install -v -m644 doc/*.txt /usr/share/doc/ffmpeg-4.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
