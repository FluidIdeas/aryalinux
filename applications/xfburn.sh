#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xfburn is a GTK+ 2 GUI frontend for Libisoburn. This is useful for creating CDsbr3ak and DVDs from files on your computer or ISO images downloaded frombr3ak elsewhere.br3ak"
SECTION="xfce"
VERSION=0.5.5
NAME="xfburn"

#REQ:exo
#REQ:libburn
#REQ:libisofs
#REQ:libxfce4ui
#REQ:gst10-plugins-base
#OPT:cdrdao


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.5.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.5.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
