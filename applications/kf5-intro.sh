#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde"
NAME="kf5-intro"



cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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

export KF5_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin kf5 extension for /etc/profile.d/qt5.sh
pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
pathappend /opt/qt5/lib/plugins QT_PLUGIN_PATH
pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
pathappend /opt/qt5/lib/qml QML2_IMPORT_PATH
# End extension for /etc/profile.d/qt5.sh
EOF
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh
export KF5_PREFIX=/usr
# End /etc/profile.d/kf5.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export KF5_PREFIX=/opt/kf5



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh
export KF5_PREFIX=/opt/kf5
pathappend /opt/kf5/bin PATH
pathappend /opt/kf5/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/kf5/etc/xdg XDG_CONFIG_DIRS
pathappend /opt/kf5/share XDG_DATA_DIRS
pathappend /opt/kf5/lib/plugins QT_PLUGIN_PATH
pathappend /opt/kf5/lib/qml QML2_IMPORT_PATH
pathappend /opt/kf5/lib/python2.7/site-packages PYTHONPATH
pathappend /opt/kf5/share/man MANPATH
# End /etc/profile.d/kf5.sh
EOF
cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin Qt5 changes for KF5
pathappend /opt/qt5/plugins QT_PLUGIN_PATH
pathappend /opt/qt5/qml QML2_IMPORT_PATH
# End Qt5 changes for KF5
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << "EOF"
# Begin KF5 addition
/opt/kf5/lib
# End KF5 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755           /opt/kf5/{etc,share} &&
ln -sfv /etc/dbus-1         /opt/kf5/etc         &&
ln -sfv /usr/share/dbus-1   /opt/kf5/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755                /opt/kf5/share/icons &&
ln -sfv /usr/share/icons/hicolor /opt/kf5/share/icons

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /opt/kf5{,-5.46.0}
ln -sfv kf5-5.46.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
