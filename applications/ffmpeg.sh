#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FFmpeg is a solution to record,br3ak convert and stream audio and video. It is a very fast video andbr3ak audio converter and it can also acquire from a live audio/videobr3ak source. Designed to be intuitive, the command-line interfacebr3ak (<span class=\"command\"><strong>ffmpeg</strong>) tries tobr3ak figure out all the parameters, when possible. FFmpeg can also convert from any sample ratebr3ak to any other, and resize video on the fly with a high qualitybr3ak polyphase filter. FFmpeg can use abr3ak Video4Linux compatible video source and any Open Sound System audiobr3ak source.br3ak"
SECTION="multimedia"
VERSION=3.4.2
NAME="ffmpeg"

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
#REC:x7driver
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
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ffmpeg.org/releases/ffmpeg-3.4.2.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

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

sed -i 's/-lflite"/-lflite -lasound"/' configure &&

./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --docdir=/usr/share/doc/ffmpeg-3.4.2 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&

install -v -m755    tools/qt-faststart /usr/bin &&
install -v -m755 -d           /usr/share/doc/ffmpeg-3.4.2 &&
install -v -m644    doc/*.txt /usr/share/doc/ffmpeg-3.4.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
