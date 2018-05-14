#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The JuffEd package is a Qt basedbr3ak editor with support for multiple tabs. It is simple and clear, butbr3ak very powerful. It supports language syntax highlighting,br3ak auto-indents in accordance with file type, code blocks folding,br3ak matching braces highlighting with instant jumps between them,br3ak powerful search and replacing text using regular expressionsbr3ak (including multiline ones) with the opportunity to use matches \1,br3ak \2, … in substitutions, a terminal emulator, saving namedbr3ak sessions and many other features.br3ak"
SECTION="postlfs"
VERSION=3
NAME="juffed"

#REQ:qscintilla
#REC:qtermwidget
#OPT:desktop-file-utils


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

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

export QT5DIR=/opt/qt5
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin           PATH
pathappend /opt/lxqt/share/man/    MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins   QT_PLUGIN_PATH
pathappend $QT5DIR/plugins         QT_PLUGIN_PATH
pathappend /opt/lxqt/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH

whoami > /tmp/currentuser

sed -i 's/"64"/""/' cmake/LibSuffix.cmake                                     &&
sed -i '/JUFFED_LIBRARY/s/)$/ qtermwidget5)/' plugins/terminal/CMakeLists.txt &&
mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DBUILD_TERMINAL=ON                 \
      -DUSE_QT5=true                      \
      ..       &&
LIBRARY_PATH=$LXQT_PREFIX/lib make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
