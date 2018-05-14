#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tumbler package contains abr3ak D-Bus thumbnailing service basedbr3ak on the thumbnail management D-Busbr3ak specification. This is useful for generating thumbnail images ofbr3ak files.br3ak"
SECTION="xfce"
VERSION=0.2.1
NAME="tumbler"

#REQ:glib2
#OPT:curl
#OPT:freetype2
#OPT:gdk-pixbuf
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libjpeg
#OPT:libgsf
#OPT:libpng
#OPT:poppler


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/tumbler/0.2/tumbler-0.2.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/xfce/tumbler/0.2/tumbler-0.2.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.2.1.tar.bz2

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

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
