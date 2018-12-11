#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libao package contains abr3ak cross-platform audio library. This is useful to output audio on abr3ak wide variety of platforms. It currently supports WAV files, OSSbr3ak (Open Sound System), ESD (Enlighten Sound Daemon), ALSA (Advancedbr3ak Linux Sound Architecture), NAS (Network Audio system), aRTS (analogbr3ak Real-Time Synthesizer), and PulseAudio (next generationbr3ak GNOME sound architecture).br3ak"
SECTION="multimedia"
VERSION=1.2.0
NAME="libao"

#OPT:pulseaudio
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libao/libao-1.2.0.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
