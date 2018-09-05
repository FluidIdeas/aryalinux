#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This package provides the GEneric Graphics Library, which is abr3ak graph based image processing format.br3ak"
SECTION="general"
VERSION=0.4.2
NAME="gegl"

#REQ:babl
#REQ:json-glib
#OPT:asciidoc
#OPT:cairo
#OPT:enscript
#OPT:exiv2
#OPT:ffmpeg
#OPT:gdk-pixbuf
#OPT:graphviz
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:libwebp
#OPT:lua
#OPT:pango
#OPT:python2
#OPT:ruby
#OPT:sdl
#OPT:gobject-introspection
#OPT:vala
#OPT:w3m
#OPT:gexiv2


cd $SOURCE_DIR

URL=https://download.gimp.org/pub/gegl/0.4/gegl-0.4.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://download.gimp.org/pub/gegl/0.4/gegl-0.4.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gegl/gegl-0.4.2.tar.bz2

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
make install &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/gegl &&
install -v -m644 docs/images/*.{png,ico,svg} /usr/share/gtk-doc/html/gegl/images

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
