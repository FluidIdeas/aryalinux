#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak QScintilla is a port tobr3ak Qt of <a class=\"ulink\" href=\"http://www.scintilla.org/\">Scintilla</a>. As well as featuresbr3ak found in standard text editing components, it includes featuresbr3ak especially useful when editing and debugging source code: languagebr3ak syntax styling, error indicators, code completion, call tips, codebr3ak folding, margins can contain markers like those used in debuggersbr3ak to indicate breakpoints and the current line, recordable macros,br3ak multiple views and, of course, printing.br3ak"
SECTION="x"
VERSION=2.10.4
NAME="qscintilla"

#REQ:chrpath
#REQ:qt5


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.10.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/pyqt/QScintilla_gpl-2.10.4.tar.gz

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

cd Qt4Qt5             &&
qmake qscintilla.pro  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv $(readlink /opt/qt5/lib/libqscintilla2_qt5.so) /opt/qt5/lib/libqt5scintilla2.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /opt/qt5/share/doc/QScintilla-2.10.4/html &&
install -v -m644    ../doc/html-Qt4Qt5/* \
                    /opt/qt5/share/doc/QScintilla-2.10.4/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
