#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gstreamer10
#REQ:libxml2
#REQ:phonon
#REC:gst10-plugins-base
#REC:gst10-plugins-good
#REC:gst10-plugins-bad
#REC:gst10-plugins-ugly

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/phonon/phonon-backend-gstreamer/4.9.0/phonon-backend-gstreamer-4.9.0.tar.xz

NAME=phonon-backend-gstreamer
VERSION=4.9.0
URL=http://download.kde.org/stable/phonon/phonon-backend-gstreamer/4.9.0/phonon-backend-gstreamer-4.9.0.tar.xz

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

cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
      -Wno-dev .. &&
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
