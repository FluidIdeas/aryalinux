#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Caribou is an input assistivebr3ak technology intended for switch and pointer users.br3ak"
SECTION="gnome"
VERSION=0.4.21
NAME="caribou"

#REQ:clutter
#REQ:gtk3
#REQ:libgee
#REQ:libxklavier
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REC:vala
#OPT:gtk2
#OPT:python-modules#dbus-python
#OPT:dconf
#OPT:python-modules#pyatspi2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz

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

PYTHON=python3 ./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtk2-module \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
