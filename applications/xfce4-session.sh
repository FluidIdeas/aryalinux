#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xfce4 Session is a session managerbr3ak for Xfce. Its task is to save thebr3ak state of your desktop (opened applications and their location) andbr3ak restore it during a next startup. You can create several differentbr3ak sessions and choose one of them on startup.br3ak"
SECTION="xfce"
VERSION=4.12.1
NAME="xfce4-session"

#REQ:libwnck2
#REQ:libxfce4ui
#REQ:general_which
#REQ:x7app
#REQ:xfdesktop
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:polkit-gnome


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/xfce4-session/4.12/xfce4-session-4.12.1.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/xfce/xfce4-session/4.12/xfce4-session-4.12.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-session-4.12.1.tar.bz2

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

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database &&
update-mime-database /usr/share/mime

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
