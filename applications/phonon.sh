#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#REQ:extra-cmake-modules
#REQ:glib2
#REQ:qt5
#REQ:phonon-backend-gstreamer
#REQ:phonon-backend-vlc


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/phonon/4.10.3/phonon-4.10.3.tar.xz


NAME=phonon
VERSION=4.10.3
URL=http://download.kde.org/stable/phonon/4.10.3/phonon-4.10.3.tar.xz

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

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
      -Wno-dev .. &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

