#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:boost
#REQ:gc
#REQ:gsl
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:libxslt
#REQ:poppler
#REQ:popt
#REQ:wget
#REQ:imagemagick6
#REQ:lcms2
#REQ:lcms
#REQ:libcanberra
#REQ:potrace
#REQ:python-modules#lxml
#REQ:python-modules#scour


cd $SOURCE_DIR

wget -nc https://media.inkscape.org/dl/resources/file/inkscape-0.92.4.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/inkscape-0.92.4-use_versioned_ImageMagick6-1.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/inkscape-0.92.4-upstream_fixes-1.patch


NAME=inkscape
VERSION=0.92.4
URL=https://media.inkscape.org/dl/resources/file/inkscape-0.92.4.tar.bz2
SECTION="Office Productivity"

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sed -e 's|new Lexer(xref, obj)|obj|g' -i src/extension/internal/pdfinput/pdf-parser.cpp
patch -Np1 -i ../inkscape-0.92.4-use_versioned_ImageMagick6-1.patch
patch -Np1 -i ../inkscape-0.92.4-upstream_fixes-1.patch
bash download-gtest.sh
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      ..                          &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                      &&
rm -v /usr/lib/inkscape/lib*_LIB.a
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

