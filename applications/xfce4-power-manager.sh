#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Xfce4 Power Manager is a powerbr3ak manager for the Xfce desktop,br3ak Xfce power manager manages thebr3ak power sources on the computer and the devices that can bebr3ak controlled to reduce their power consumption (such as LCDbr3ak brightness level, monitor sleep, CPU frequency scaling). Inbr3ak addition, Xfce4 Power Managerbr3ak provides a set of freedesktop-compliant DBus interfaces to inform other applicationsbr3ak about current power level so that they can adjust their powerbr3ak consumption.br3ak"
SECTION="xfce"
VERSION=1.6.1
NAME="xfce4-power-manager"

#REQ:libnotify
#REQ:upower
#REQ:xfce4-panel


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/xfce4-power-manager/1.6/xfce4-power-manager-1.6.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/xfce/xfce4-power-manager/1.6/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-power-manager-1.6.1.tar.bz2

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
