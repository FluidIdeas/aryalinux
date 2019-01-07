#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=kf5-intro
VERSION=""
URL=""

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

export KF5_PREFIX=/usr

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin kf5 extension for /etc/profile.d/qt5.sh

pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
pathappend $QT5DIR/lib/plugins QT_PLUGIN_PATH

pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
pathappend $QT5DIR/lib/qml QML2_IMPORT_PATH

# End extension for /etc/profile.d/qt5.sh
EOF

cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/usr

# End /etc/profile.d/kf5.sh
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/sudoers.d/qt << "EOF
Defaults env_keep += QT_PLUGIN_PATH
Defaults env_keep += QML2_IMPORT_PATH
EOF

cat >> /etc/sudoers.d/kde << "EOF
Defaults env_keep += KF5_PREFIX
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

export KF5_PREFIX=/opt/kf5

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/opt/kf5

pathappend $KF5_PREFIX/bin PATH
pathappend $KF5_PREFIX/lib/pkgconfig PKG_CONFIG_PATH

pathappend $KF5_PREFIX/etc/xdg XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/share XDG_DATA_DIRS

pathappend $KF5_PREFIX/lib/plugins QT_PLUGIN_PATH

pathappend $KF5_PREFIX/lib/qml QML2_IMPORT_PATH

pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH

pathappend $KF5_PREFIX/share/man MANPATH
# End /etc/profile.d/kf5.sh
EOF

cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin Qt5 changes for KF5

pathappend $QT5DIR/plugins QT_PLUGIN_PATH
pathappend $QT5DIR/qml QML2_IMPORT_PATH

# End Qt5 changes for KF5
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << "EOF"
# Begin KF5 addition

/opt/kf5/lib

# End KF5 addition
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 $KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1 $KF5_PREFIX/etc &&
ln -sfv /usr/share/dbus-1 $KF5_PREFIX/share
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 $KF5_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv /opt/kf5{,-5.53.0}
ln -sfv kf5-5.53.0 /opt/kf5
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
