#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The K3b package contains abr3ak KF5-based graphical interface to the Cdrtools and dvd+rw-tools CD/DVD manipulation tools. Itbr3ak also combines the capabilities of many other multimedia packagesbr3ak into one central interface to provide a simple-to-operatebr3ak application that can be used to handle many of your CD/DVDbr3ak recording and formatting requirements. It is used for creatingbr3ak audio, data, video and mixed-mode CDs as well as copying, rippingbr3ak and burning CDs and DVDs.br3ak"
SECTION="kde"
VERSION=17.12.2
NAME="k3b"

#REQ:libkcddb
#REQ:libsamplerate
#REQ:shared-mime-info
#REQ:kframeworks5
#REC:ffmpeg
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

URL=http://download.kde.org/stable/applications/17.12.2/src/k3b-17.12.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/17.12.2/src/k3b-17.12.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/k3b/k3b-17.12.2.tar.xz

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

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..                        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
