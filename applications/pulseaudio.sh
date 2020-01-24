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

wget -nc https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-12.2.tar.xz


NAME=pulseaudio
VERSION=12.2
URL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-12.2.tar.xz
SECTION="Multimedia"
DESCRIPTION="PulseAudio is a sound system for POSIX OSes, meaning that it is a proxy for sound applications. It allows you to do advanced operations on your sound data as it passes between your application and your hardware. Things like transferring the audio to a different machine, changing the sample format or channel count and mixing several sounds into one are easily achieved using a sound server."

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


sed -i "s:asoundlib.h:alsa/asoundlib.h:" src/modules/alsa/*.{c,h} &&
sed -i "s:use-case.h:alsa/use-case.h:" configure.ac &&
sed -i "s:use-case.h:alsa/use-case.h:" src/modules/alsa/alsa-ucm.h
NOCONFIGURE=1 ./bootstrap.sh     &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-bluez4     \
            --disable-bluez5     \
            --disable-rpath      &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

