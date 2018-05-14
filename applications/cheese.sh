#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Cheese is used to take photos andbr3ak videos with fun graphical effects.br3ak"
SECTION="gnome"
VERSION=3.28.0
NAME="cheese"

#REQ:clutter-gst
#REQ:clutter-gtk
#REQ:gnome-desktop
#REQ:gnome-video-effects
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-good
#REQ:v4l-utils
#REQ:itstool
#REQ:libcanberra
#REQ:libgudev
#REQ:clutter-gst2
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/cheese/3.28/cheese-3.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/cheese/3.28/cheese-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cheese/cheese-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cheese/3.28/cheese-3.28.0.tar.xz

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
