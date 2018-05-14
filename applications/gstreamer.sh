#!/bin/bash

set -e

. /etc/alps/alps.conf

NAME="gstreamer"
VERSION="0.10.36"
. /var/lib/alps/functions

#REQ:glib2
#REQ:libxml2
#OPT:gobject-introspection
#OPT:gsl
#OPT:valgrind
#OPT:gtk-doc
#OPT:python2
#OPT:docbook-utils
#OPT:gs
#OPT:libxslt
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gstreamer/0.10/gstreamer-0.10.36.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gstreamer/0.10/gstreamer-0.10.36.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gstreamer/0.10/gstreamer-0.10.36.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed -i  -e '/YYLEX_PARAM/d'                                       \
        -e '/parse-param.*scanner/i %lex-param { void *scanner }' \
            gst/parse/grammar.y &&
./configure --prefix=/usr    \
            --disable-static \
            --with-package-name="GStreamer 0.10.36 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/gstreamer-0.10/design &&
install -v -m644 docs/design/*.txt \
                    /usr/share/doc/gstreamer-0.10/design &&
if [ -d /usr/share/doc/gstreamer-0.10/faq/html ]; then
    chown -Rv root:root \
        /usr/share/doc/gstreamer-0.10/*/html
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


gst-launch -v fakesrc num_buffers=5 ! fakesink


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
