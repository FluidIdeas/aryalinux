#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXDE Common package provides abr3ak set of default configuration for LXDE.br3ak"
SECTION="lxde"
VERSION=0.99.2
NAME="lxde-common"

#REQ:lxde-icon-theme
#REQ:lxpanel
#REQ:lxsession
#REQ:openbox
#REQ:pcmanfm
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#REC:dbus
#OPT:notification-daemon
#OPT:xfce4-notifyd
#OPT:lxdm
#OPT:lightdm


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.2.tar.xz

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.xinitrc << "EOF"
# No need to run dbus-launch, since it is run by startlxde
startlxde
EOF
startx


startx &> ~/.x-session-errors




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
