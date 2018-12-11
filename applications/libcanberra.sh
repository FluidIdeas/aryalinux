#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libcanberra is an implementationbr3ak of the XDG Sound Theme and Name Specifications, for generatingbr3ak event sounds on free desktops, such as GNOME.br3ak"
SECTION="multimedia"
VERSION=0.30
NAME="libcanberra"

#REQ:libvorbis
#REC:alsa-lib
#REC:gstreamer10
#REC:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz

if [ ! -z $URL ]
then
wget -nc http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz

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

./configure --prefix=/usr --disable-oss &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libcanberra-0.30 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
