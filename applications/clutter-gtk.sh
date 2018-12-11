#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Clutter Gtk package is abr3ak library providing facilities to integrate Clutter into GTK+ applications.br3ak"
SECTION="x"
VERSION=1.8.4
NAME="clutter-gtk"

#REQ:clutter
#REQ:gtk3
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.4.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.4.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.4.tar.xz

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
