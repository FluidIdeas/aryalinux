#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Inkscape is a what you see is whatbr3ak you get Scalable Vector Graphics editor. It is useful for creating,br3ak viewing and changing SVG images.br3ak"
SECTION="xsoft"
VERSION=0.92.3
NAME="inkscape"

#REQ:boost
#REQ:gc
#REQ:gsl
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:libxslt
#REQ:poppler
#REQ:popt
#REQ:wget
#REC:imagemagick6
#REC:lcms2
#REC:lcms
#REC:potrace
#REC:python-modules#lxml
#REC:python-modules#scour
#OPT:aspell
#OPT:dbus
#OPT:doxygen


cd $SOURCE_DIR

URL=https://media.inkscape.org/dl/resources/file/inkscape-0.92.3.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://media.inkscape.org/dl/resources/file/inkscape-0.92.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.92.3.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/inkscape-0.92.3-use_versioned_ImageMagick6-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/inkscape/inkscape-0.92.3-use_versioned_ImageMagick6-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/inkscape-0.92.3-poppler64-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/inkscape/inkscape-0.92.3-poppler64-1.patch

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

patch -Np1 -i ../inkscape-0.92.3-use_versioned_ImageMagick6-1.patch &&
patch -Np1 -i ../inkscape-0.92.3-poppler64-1.patch


sed -i 's| abs(| std::fabs(|g' src/ui/tools/flood-tool.cpp


bash download-gtest.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      ..                          &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                      &&
rm -v /usr/lib/inkscape/lib*_LIB.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
