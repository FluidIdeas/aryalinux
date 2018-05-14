#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FLTK (pronounced \"fulltick\") is a cross-platform C++ GUI toolkit.br3ak FLTK provides modern GUI functionality and supports 3D graphics viabr3ak OpenGL and its built-in GLUT emulation libraries used for creatingbr3ak graphical user interfaces for applications.br3ak"
SECTION="x"
VERSION=1.3.4
NAME="fltk"

#REQ:x7lib
#REC:hicolor-icon-theme
#REC:libjpeg
#REC:libpng
#OPT:alsa-lib
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:glu
#OPT:mesa
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz

if [ ! -z $URL ]
then
wget -nc http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz

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

sed -i -e '/cat./d' documentation/Makefile       &&
./configure --prefix=/usr    \
            --enable-shared  &&
make "-j`nproc`" || make


make -C documentation html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/fltk-1.3.4 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
