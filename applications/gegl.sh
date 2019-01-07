#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:babl
#REQ:json-glib
#OPT:asciidoc
#OPT:cairo
#OPT:enscript
#OPT:exiv2
#OPT:gdk-pixbuf
#OPT:graphviz
#OPT:libjpeg
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

wget -nc https://download.gimp.org/pub/gegl/0.4/gegl-0.4.12.tar.bz2

NAME=gegl
VERSION=0.4.12.
URL=https://download.gimp.org/pub/gegl/0.4/gegl-0.4.12.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/gegl &&
install -v -m644 docs/images/*.{png,ico,svg} /usr/share/gtk-doc/html/gegl/images
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
