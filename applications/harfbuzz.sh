#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:glib2
#REC:texlive
#REC:libreoffice
#REC:icu
#REC:freetype2
#REC:harfbuzz
#REC:freetype2
#OPT:cairo
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python2

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.0.tar.bz2

NAME=harfbuzz
VERSION=2.3.0.
URL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.0.tar.bz2

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

./configure --prefix=/usr --with-gobject --with-graphite2 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
