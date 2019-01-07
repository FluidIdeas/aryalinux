#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=xorg-config
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

xrandr --listproviders
xrandr --setprovideroffloadsink <em class="replaceable"><code><provider> <sink></code></em>
DRI_PRIME=1 glxinfo | egrep "(OpenGL vendor|OpenGL renderer|OpenGL version)"

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/xkb-defaults.conf << "EOF"
Section "InputClass"
Identifier "XKB Defaults"
MatchIsKeyboard "yes"
Option "XkbLayout" "fr"
Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
Section "Device"
Identifier "Videocard0"
Driver "radeon"
VendorName "Videocard vendor"
BoardName "ATI Radeon 7500"
Option "NoAccel" "true"
EndSection
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/X11/xorg.conf.d/server-layout.conf << "EOF"
Section "ServerLayout"
Identifier "DefaultLayout"
Screen 0 "Screen0" 0 0
Screen 1 "Screen1" LeftOf "Screen0"
Option "Xinerama"
EndSection
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
