#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:krameworks5
#REQ:libkcddb
#REQ:libsamplerate
#REQ:shared-mime-info
#REC:ffmpeg
#REC:libburn
#REC:libdvdread
#REC:taglib
#REC:cdrtools
#REC:dvd-rw-tools
#REC:cdrdao
#OPT:flac
#OPT:lame
#OPT:libmad
#OPT:libsndfile
#OPT:libvorbis
#OPT:libmusicbrainz

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/applications/18.08.0/src/k3b-18.08.0.tar.xz

URL=http://download.kde.org/stable/applications/18.08.0/src/k3b-18.08.0.tar.xz

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

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..                        &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
