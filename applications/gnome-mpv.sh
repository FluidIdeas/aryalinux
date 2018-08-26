#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Gnome MPV is a video player frontend to the mpv backend"
SECTION="multimedia"
VERSION=0.14
NAME="gnome-mpv"

#REQ:mpv

cd $SOURCE_DIR

URL=https://github.com/gnome-mpv/gnome-mpv/releases/download/v0.14/gnome-mpv-0.14.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/gnome-mpv-0.14-locale.patch

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

patch -Np1 -i ../gnome-mpv-0.14-locale.patch
./configure --prefix=/usr &&
make -j$(nproc)
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
