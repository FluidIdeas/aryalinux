#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Graphviz package containsbr3ak graph visualization software. Graph visualization is a way ofbr3ak representing structural information as diagrams of abstract graphsbr3ak and networks. Graphviz has severalbr3ak main graph layout programs. It also has web and interactivebr3ak graphical interfaces, auxiliary tools, libraries, and languagebr3ak bindings.br3ak"
SECTION="general"
VERSION=null
NAME="graphviz"

#OPT:pango
#OPT:cairo
#OPT:x7lib
#OPT:fontconfig
#OPT:libpng
#OPT:gtk2
#OPT:libjpeg
#OPT:libwebp
#OPT:gs
#OPT:librsvg
#OPT:poppler
#OPT:freeglut
#OPT:libglade
#OPT:qt5
#OPT:swig
#OPT:gcc
#OPT:guile
#OPT:openjdk
#OPT:lua
#OPT:php
#OPT:python2
#OPT:ruby
#OPT:tcl
#OPT:tk


cd $SOURCE_DIR

URL=http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz

if [ ! -z $URL ]
then
wget -nc http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphviz/graphviz.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/graphviz/graphviz.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/graphviz-2.40.1-qt5-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/graphviz/graphviz-2.40.1-qt5-1.patch

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

wget -c http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz \
     -O graphviz-2.40.1.tar.gz


sed -e '/ruby/s/1\.9/2.4/' -i configure.ac


patch -p1 -i ../graphviz-2.40.1-qt5-1.patch


sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&
autoreconf                &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s /usr/share/graphviz/doc \
         /usr/share/doc/graphviz-2.40.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
