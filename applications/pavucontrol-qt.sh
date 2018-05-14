#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak pavucontrol-qt is the Qt port ofbr3ak volume control pavucontrol of sound server PulseAudio. Its use isbr3ak not limited to LXQt.br3ak"
SECTION="lxqt"
VERSION=0.3.0
NAME="pavucontrol-qt"

#REQ:liblxqt
#REQ:pulseaudio
#REQ:glib2
#OPT:git
#OPT:lxqt-l10n


cd $SOURCE_DIR

URL=https://github.com/lxde/pavucontrol-qt/releases/download/0.3.0/pavucontrol-qt-0.3.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/lxde/pavucontrol-qt/releases/download/0.3.0/pavucontrol-qt-0.3.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.3.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ "$LXQT_PREFIX" != /usr ]; then
  ln -svf $LXQT_PREFIX/share/applications/pavucontrol-qt.desktop \
          /usr/share/applications
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
