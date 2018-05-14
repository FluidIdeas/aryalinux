#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Nautilus package contains thebr3ak GNOME file manager.br3ak"
SECTION="gnome"
VERSION=3.28.0.1
NAME="nautilus"

#REQ:gexiv2
#REQ:gnome-autoar
#REQ:gnome-desktop
#REQ:tracker
#REQ:libnotify
#REC:exempi
#REC:gobject-introspection
#REC:libexif
#REC:adwaita-icon-theme
#REC:gvfs
#REQ:appstream-glib
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.0.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.28.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.28/nautilus-3.28.0.1.tar.xz

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

sed s/\'libm\'/\'m\'/ -i meson.build &&
mkdir build &&
cd    build &&
meson --prefix=/usr      \
      --sysconfdir=/etc  \
      -Dselinux=false    \
      -Dpackagekit=false \
      .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install &&
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
