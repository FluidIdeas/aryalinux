#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak VLC is a media player, streamer,br3ak and encoder. It can play from many inputs, such as files, networkbr3ak streams, capture devices, desktops, or DVD, SVCD, VCD, and audiobr3ak CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1,br3ak DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert tobr3ak different formats and/or send streams through the network.br3ak"
SECTION="multimedia"
VERSION=3.0.3
NAME="vlc"

#REC:alsa-lib
#REC:ffmpeg
#REC:liba52
#REC:libgcrypt
#REC:libmad
#REC:lua
#REC:xorg-server
#REC:dbus
#REC:libcddb
#REC:libdv
#REC:libdvdcss
#REC:libdvdread
#REC:libdvdnav
#REC:opencv
#OPT:samba
#REC:v4l-utils
#REC:libcdio
#REC:libogg
#REC:faad2
#REC:flac
#REC:libass
#REC:libmpeg2
#REC:libpng
#REC:libtheora
#REC:x7driver
#REC:libvorbis
#OPT:opus
#OPT:speex
#REC:x264
#REC:x265
#REC:aalib
#REC:fontconfig
#REC:freetype2
#REC:fribidi
#REC:librsvg
#REC:sdl
#REC:pulseaudio
#REC:libsamplerate
#OPT:qt5
#REC:avahi
#REC:gnutls
#REC:libnotify
#OPT:libxml2
#OPT:taglib
#OPT:xdg-utils


cd $SOURCE_DIR

URL=https://download.videolan.org/vlc/3.0.3/vlc-3.0.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.videolan.org/vlc/3.0.3/vlc-3.0.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.3.tar.xz

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

sed -i '/vlc_demux.h/a #define LUA_COMPAT_APIINTCASTS' modules/lua/vlc.h   &&
sed -i '/DEPRECATED/s:^://:'  modules/text_renderer/freetype/text_layout.c &&
sed -i '/#include <QString>/i#include <QButtonGroup>' \
        modules/gui/qt/components/simple_preferences.cpp                   &&
BUILDCC=gcc ./configure --prefix=/usr --disable-opencv &&
make "-j`nproc`" || make
sudo make docdir=/usr/share/doc/vlc-3.0.3 install
sudo gtk-update-icon-cache &&
sudo update-desktop-database



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
