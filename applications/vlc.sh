#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:alsa-lib
#REQ:desktop-file-utils
#REQ:ffmpeg
#REQ:liba52
#REQ:libgcrypt
#REQ:libmad
#REQ:lua52
#REQ:qt5


cd $SOURCE_DIR

wget -nc https://download.videolan.org/vlc/3.0.12/vlc-3.0.12.tar.xz


NAME=vlc
VERSION=3.0.12
URL=https://download.videolan.org/vlc/3.0.12/vlc-3.0.12.tar.xz
SECTION="Video Utilities"
DESCRIPTION="VLC is a media player, streamer, and encoder. It can play from many inputs, such as files, network streams, capture devices, desktops, or DVD, SVCD, VCD, and audio CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1, DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert to different formats and/or send streams through the network."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


export LUAC=/usr/bin/luac5.2                   &&
export LUA_LIBS="$(pkg-config --libs lua52)"   &&
export CPPFLAGS="$(pkg-config --cflags lua52)" &&

BUILDCC=gcc ./configure --prefix=/usr    \
                        --disable-opencv \
                        --disable-vpx    &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/vlc-3.0.12 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

