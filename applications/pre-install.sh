#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="lxqt"
NAME="pre-install"



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

export LXQT_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/usr
# End LXQt profile
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/lxqt/{bin,lib,share/man}
cat > /etc/profile.d/lxqt.sh << "EOF"
# Begin LXQt profile
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin PATH
pathappend /opt/lxqt/share/man/ MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins QT_PLUGIN_PATH
# End LXQt profile
EOF
cat >> /etc/profile.d/qt5.sh << "EOF"

# Begin Qt5 changes for LXQt
pathappend /opt/qt5/plugins QT_PLUGIN_PATH
# End Qt5 changes for LXQt
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << "EOF"

# Begin LXQt addition
/opt/lxqt/lib
# End LXQt addition

EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


source /etc/profile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
source /etc/profile                                       &&
install -v -dm755                $LXQT_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $LXQT_PREFIX/share/icons &&
ln -sfv /usr/share/dbus-1        $LXQT_PREFIX/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /opt/lxqt{,-0.12.0}
ln -sfv lxqt-0.12.0 /opt/lxqt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


ls -Fd qt* | grep / | sed 's/^/-skip /;s/qt//;s@/@@' > tempconf
sed -i '/base/d;/tools/d;/x11extras/d;/svg/d' tempconf
# if you plan to build SDDM, add:
sed -i '/declarative/d' tempconf
./configure <book flags> $(cat tempconf)




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
