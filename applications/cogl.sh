#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Cogl is a modern 3D graphics APIbr3ak with associated utility APIs designed to expose the features of 3Dbr3ak graphics hardware using a direct state access API design, asbr3ak opposed to the state-machine style of OpenGL.br3ak"
SECTION="x"
VERSION=1.22.2
NAME="cogl"

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REQ:wayland
#REC:gobject-introspection
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:sdl
#OPT:sdl2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

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

sed -i 's/^#if COGL/#ifdef COGL/' cogl/winsys/cogl-winsys-egl.c &&
./configure --prefix=/usr --enable-gles1 --enable-gles2 --enable-kms-egl-platform --enable-wayland-egl-platform --enable-xlib-egl-platform --enable-wayland-egl-server         \
    --enable-{kms,wayland,xlib}-egl-platform                    \
    --enable-wayland-egl-server                                 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
