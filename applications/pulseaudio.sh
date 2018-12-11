#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak PulseAudio is a sound system forbr3ak POSIX OSes, meaning that it is a proxy for sound applications. Itbr3ak allows you to do advanced operations on your sound data as itbr3ak passes between your application and your hardware. Things likebr3ak transferring the audio to a different machine, changing the samplebr3ak format or channel count and mixing several sounds into one arebr3ak easily achieved using a sound server.br3ak"
SECTION="multimedia"
VERSION=12.2
NAME="pulseaudio"

#REQ:libsndfile
#REQ:bluez
#REQ:sbc
#REC:alsa-lib
#REC:dbus
#REC:glib2
#REC:libcap
#REC:speex
#REC:x7lib
#OPT:avahi
#OPT:bluez
#OPT:fftw
#OPT:GConf
#OPT:gtk3
#OPT:libsamplerate
#OPT:sbc
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-12.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-12.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-12.2.tar.xz

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-bluez5 --enable-bluez5-ofono-headset     \
            --disable-bluez5     \
            --disable-rpath      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -fv /etc/dbus-1/system.d/pulseaudio-system.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
