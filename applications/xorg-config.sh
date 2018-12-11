#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="x"
NAME="xorg-config"



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

xrandr --listproviders


xrandr --setprovideroffloadsink <em class="replaceable"><code><provider> <sink></em>


DRI_PRIME=1 glxinfo | egrep "(OpenGL vendor|OpenGL renderer|OpenGL version)"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/xkb-defaults.conf << "EOF"
Section "InputClass"
    Identifier "XKB Defaults"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "fr"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
Section "Device"
    Identifier  "Videocard0"
    Driver      "radeon"
    VendorName  "Videocard vendor"
    BoardName   "ATI Radeon 7500"
    Option      "NoAccel" "true"
EndSection
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/server-layout.conf << "EOF"
Section "ServerLayout"
    Identifier     "DefaultLayout"
    Screen      0  "Screen0" 0 0
    Screen      1  "Screen1" LeftOf "Screen0"
    Option         "Xinerama"
EndSection
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
