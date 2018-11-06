#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak EOG is an application used forbr3ak viewing and cataloging image files on the GNOME Desktop. It has basic editingbr3ak capabilites.br3ak"
SECTION="gnome"
VERSION=3.28.3
NAME="eog"

#REQ:adwaita-icon-theme
#REQ:exempi
#REQ:gnome-desktop
#REQ:itstool
#REQ:libpeas
#REQ:shared-mime-info
#REC:gobject-introspection
#REC:lcms2
#REC:libexif
#REC:librsvg
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/eog/3.28/eog-3.28.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/eog/3.28/eog-3.28.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/eog/eog-3.28.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/eog/3.28/eog-3.28.3.tar.xz

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
