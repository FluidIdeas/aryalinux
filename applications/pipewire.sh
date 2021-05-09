#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:bluez
#REQ:ffmpeg
#REQ:gstreamer10
#REQ:gst10-plugins-base
#REQ:libva
#REQ:pulseaudio
#REQ:sbc
#REQ:sdl2
#REQ:v4l-utils
#REQ:jack2


cd $SOURCE_DIR

wget -nc https://github.com/PipeWire/pipewire/archive/0.3.26/pipewire-0.3.26.tar.gz


NAME=pipewire
VERSION=0.3.26
URL=https://github.com/PipeWire/pipewire/archive/0.3.26/pipewire-0.3.26.tar.gz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The pipewire package contains a server and user-space API to handle multimedia pipelines. This includes a universal API to connect to multimedia devices, as well as sharing multimedia files between applications."

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

meson --prefix=/usr .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

