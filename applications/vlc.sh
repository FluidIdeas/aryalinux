#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak VLC is a media player, streamer,br3ak and encoder. It can play from many inputs, such as files, networkbr3ak streams, capture devices, desktops, or DVD, SVCD, VCD, and audiobr3ak CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1,br3ak DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert tobr3ak different formats and/or send streams through the network.br3ak"
SECTION="multimedia"
VERSION=3.0.2
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
#REC:samba
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
#REC:opus
#REC:speex
#REC:x264
#REC:aalib
#REC:fontconfig
#REC:freetype2
#REC:fribidi
#REC:librsvg
#REC:sdl
#REC:pulseaudio
#REC:libsamplerate
#REC:qt5
#REC:avahi
#REC:gnutls
#REC:libnotify
#REC:libxml2
#REC:taglib
#REC:xdg-utils


cd $SOURCE_DIR

URL=https://download.videolan.org/vlc/3.0.2/vlc-3.0.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.videolan.org/vlc/3.0.2/vlc-3.0.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.2.tar.xz

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

export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
sed -i '/vlc_demux.h/a #define LUA_COMPAT_APIINTCASTS' modules/lua/vlc.h   &&
sed -i '/DEPRECATED/s:^://:'  modules/text_renderer/freetype/text_layout.c &&
BUILDCC=gcc ./configure --prefix=/usr --disable-opencv &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make docdir=/usr/share/doc/vlc-3.0.2 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
