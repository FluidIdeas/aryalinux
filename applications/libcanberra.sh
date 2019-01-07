#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libvorbis
#REC:alsa-lib
#REC:gstreamer10
#REC:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:pulseaudio

cd $SOURCE_DIR

wget -nc http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz

NAME=libcanberra
VERSION=0.30
URL=http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz

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

./configure --prefix=/usr --disable-oss &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libcanberra-0.30 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
