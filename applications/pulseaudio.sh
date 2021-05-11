#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libsndfile
#REQ:alsa-lib
#REQ:dbus
#REQ:glib2
#REQ:libcap
#REQ:speex
#REQ:x7lib


cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.xz


NAME=pulseaudio
VERSION=14.2
URL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="PulseAudio is a sound system for POSIX OSes, meaning that it is a proxy for sound applications. It allows you to do advanced operations on your sound data as it passes between your application and your hardware. Things like transferring the audio to a different machine, changing the sample format or channel count and mixing several sounds into one are easily achieved using a sound server."

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


sed '/doxygen/d' -i meson.build
mkdir build &&
cd    build &&

meson  --prefix=/usr -Ddatabase=gdbm -Dbluez5=false &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -fv /etc/dbus-1/system.d/pulseaudio-system.conf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

