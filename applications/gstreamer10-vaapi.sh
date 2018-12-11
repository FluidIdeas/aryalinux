#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The gstreamer-vaapi packagebr3ak contains a gstreamer plugin forbr3ak hardware accelerated video decode/encode for the prevailing codingbr3ak standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, andbr3ak VC-1/VMW3).br3ak"
SECTION="multimedia"
VERSION=1.14.4
NAME="gstreamer10-vaapi"

#REQ:gstreamer10
#REQ:gst10-plugins-base
#REQ:gst10-plugins-bad
#REQ:x7driver


cd $SOURCE_DIR

URL=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.14.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.14.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.14.4.tar.xz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
