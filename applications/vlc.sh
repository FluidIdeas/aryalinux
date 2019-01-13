#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:alsa-lib
#REC:ffmpeg
#REC:liba52
#REC:libgcrypt
#REC:libmad
#REC:lua
#OPT:dbus
#OPT:libcddb
#OPT:libdv
#OPT:libdvdcss
#OPT:libdvdread
#OPT:libdvdnav
#OPT:opencv
#OPT:samba
#OPT:v4l-utils
#OPT:libbluray
#OPT:libcdio
#OPT:libogg
#OPT:libdvbpsi
#OPT:faad2
#OPT:flac
#OPT:libass
#OPT:libmpeg2
#OPT:libpng
#OPT:libtheora
#OPT:libva
#OPT:libvorbis
#OPT:opus
#OPT:speex
#OPT:x264
#OPT:libdca
#OPT:aalib
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:librsvg
#OPT:libvdpau
#OPT:sdl
#OPT:pulseaudio
#OPT:libsamplerate
#OPT:qt5
#OPT:avahi
#OPT:gnutls
#OPT:libnotify
#OPT:libxml2
#OPT:taglib
#OPT:xdg-utils
#OPT:atmolight

cd $SOURCE_DIR

wget -nc https://download.videolan.org/vlc/3.0.5/vlc-3.0.5.tar.xz

NAME=vlc
VERSION=3.0.5
URL=https://download.videolan.org/vlc/3.0.5/vlc-3.0.5.tar.xz

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

sed -i '/vlc_demux.h/a #define LUA_COMPAT_APIINTCASTS' modules/lua/vlc.h &&
sed -i '/DEPRECATED/s:^://:' modules/text_renderer/freetype/text_layout.c &&
sed -i '/118/s/$/\&\& X264_BUILD < 153/' modules/codec/x264.c &&

BUILDCC=gcc ./configure --prefix=/usr --disable-opencv &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/vlc-3.0.5 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
