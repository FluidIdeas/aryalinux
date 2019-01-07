#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:boost
#REQ:gc
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:poppler
#REQ:popt
#REQ:wget
#REC:imagemagick6
#REC:lcms2
#REC:lcms
#REC:potrace
#REC:lxml
#REC:scour
#OPT:aspell
#OPT:dbus
#OPT:doxygen

cd $SOURCE_DIR

wget -nc https://media.inkscape.org/dl/resources/file/inkscape-0.92.3.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/inkscape-0.92.3-consolidated_fixes-1.patch

NAME=inkscape
VERSION=0.92.3.
URL=https://media.inkscape.org/dl/resources/file/inkscape-0.92.3.tar.bz2

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

patch -Np1 -i ../inkscape-0.92.3-consolidated_fixes-1.patch
sed -i 's| abs(| std::fabs(|g' src/ui/tools/flood-tool.cpp &&
sed -e 's|gTrue|true|g' -e 's|gFalse|false|g' -e 's|GBool|bool|g' \
-i src/extension/internal/pdfinput/pdf-parser.*
bash download-gtest.sh
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -v /usr/lib/inkscape/lib*_LIB.a
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
