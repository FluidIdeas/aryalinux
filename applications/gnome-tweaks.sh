#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GNOME Tweaks is a simple programbr3ak used to tweak advanced GNOMEbr3ak settings.br3ak"
SECTION="gnome"
VERSION=3.28.1
NAME="gnome-tweaks"

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-tweaks/3.28/gnome-tweaks-3.28.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-tweaks/3.28/gnome-tweaks-3.28.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweaks/gnome-tweaks-3.28.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-tweaks/3.28/gnome-tweaks-3.28.1.tar.xz

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

mkdir build &&
cd    build &&
meson --prefix=/usr &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
