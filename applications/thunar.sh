#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Thunar is the Xfce file manager, a GTK+ 2 GUI to organise the files on yourbr3ak computer.br3ak"
SECTION="xfce"
VERSION=1.7.0
NAME="thunar"

#REQ:exo
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libgudev
#REC:libnotify
#REC:xfce4-panel
#OPT:gvfs
#OPT:libexif
#OPT:tumbler


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/thunar/1.7/Thunar-1.7.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/xfce/thunar/1.7/Thunar-1.7.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/thunar/Thunar-1.7.0.tar.bz2

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
            --docdir=/usr/share/doc/Thunar-1.7.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
