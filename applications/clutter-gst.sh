#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Clutter Gst package containsbr3ak an integration library for using GStreamer with Clutter. Its purpose is to implement thebr3ak ClutterMedia interface using GStreamer.br3ak"
SECTION="x"
VERSION=3.0.26
NAME="clutter-gst"

#REQ:clutter
#REQ:gst10-plugins-base
#REQ:libgudev
#REC:gobject-introspection
#REC:gst10-plugins-bad
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.26.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gst-3.0.26.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.26.tar.xz

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
