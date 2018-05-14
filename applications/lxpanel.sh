#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXPanel package contains abr3ak lightweight X11 desktop panel.br3ak"
SECTION="lxde"
VERSION=0.9.3
NAME="lxpanel"

#REQ:keybinder
#REQ:libwnck2
#REQ:lxmenu-data
#REQ:menu-cache
#REC:alsa-lib
#REC:libxml2
#REC:wireless_tools


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxde/lxpanel-0.9.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxde/lxpanel-0.9.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxpanel/lxpanel-0.9.3.tar.xz

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
