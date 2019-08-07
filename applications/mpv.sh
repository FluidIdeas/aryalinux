#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:xserver-meta
#REQ:mesa
#REQ:alsa-lib
#REQ:pulseaudio
#REQ:libass
#REQ:libjpeg
#REQ:gnutls
#REQ:x264
#REQ:lame
#REQ:fdk-aac


cd $SOURCE_DIR

wget -nc https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz


NAME=mpv
VERSION=0.29.1
URL=https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz

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

./bootstrap.py &&
./waf configure --enable-libmpv-shared --enable-vaapi --enable-vdpau --prefix=/usr &&
./waf build &&
sudo ./waf install --prefix=/usr


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

