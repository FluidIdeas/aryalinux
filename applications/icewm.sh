#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak IceWM is a window manager with thebr3ak goals of speed, simplicity, and not getting in the user's way.br3ak"
SECTION="x"
VERSION=1.4.2
NAME="icewm"

#REQ:gdk-pixbuf
#REQ:xorg-server
#OPT:fribidi
#OPT:libsndfile
#OPT:alsa-lib


cd $SOURCE_DIR

URL=https://github.com/bbidulock/icewm/releases/download/1.4.2/icewm-1.4.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://github.com/bbidulock/icewm/releases/download/1.4.2/icewm-1.4.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icewm/icewm-1.4.2.tar.bz2

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

./configure --prefix=/usr                     \
            --sysconfdir=/etc                 \
            --docdir=/usr/share/doc/icewm-1.4.2 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install         &&
rm /usr/share/xsessions/icewm.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


echo icewm-session > ~/.xinitrc


mkdir -v ~/.icewm                                       &&
cp -v /usr/share/icewm/keys ~/.icewm/keys               &&
cp -v /usr/share/icewm/menu ~/.icewm/menu               &&
cp -v /usr/share/icewm/preferences ~/.icewm/preferences &&
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar         &&
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions


icewm-menu-fdo >~/.icewm/menu


cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF &&
chmod +x ~/.icewm/startup




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
