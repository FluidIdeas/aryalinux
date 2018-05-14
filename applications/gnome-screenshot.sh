#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Screenshot is a utilitybr3ak used for taking screenshots of the entire screen, a window or abr3ak user-defined area of the screen, with optional beautifying borderbr3ak effects.br3ak"
SECTION="gnome"
VERSION=3.26.0
NAME="gnome-screenshot"

#REQ:gtk3
#REQ:libcanberra


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-screenshot/gnome-screenshot-3.26.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.26/gnome-screenshot-3.26.0.tar.xz

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

sed -e '/AppData/N;N;p;s/\.appdata\./.metainfo./' \
    -i /usr/share/gettext-0.19.8/its/appdata.loc


mkdir build &&
cd    build &&
meson --prefix=/usr .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
