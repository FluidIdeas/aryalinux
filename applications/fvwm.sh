#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cairo
#REQ:fontconfig
#REQ:freetype2
#REQ:fribidi
#REQ:gdk-pixbuf
#REQ:python-modules#pyxdg


cd $SOURCE_DIR

wget -nc https://github.com/fvwmorg/fvwm/releases/download/2.6.9/fvwm-2.6.9.tar.gz


NAME=fvwm
VERSION=2.6.9
URL=https://github.com/fvwmorg/fvwm/releases/download/2.6.9/fvwm-2.6.9.tar.gz
SECTION="Window Managers"
DESCRIPTION="FVWM is an extremely powerful ICCCM-compliant multiple virtual desktop window manager for the X Window system."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr --sysconfdir=/etc --libexecdir=/usr/lib &&
make

cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
touch /usr/share/xsessions/fvwm.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

echo exec fvwm > ~/.xinitrc

cat > /usr/share/xsessions/fvwm.desktop <<"ENDOFDESKTOPFILE"
[Desktop Entry]
Encoding=UTF-8
Name=FVWM
Comment=The fvwm window manager
Type=XSession
Exec=/usr/bin/fvwm
TryExec=/usr/bin/fvwm
ENDOFDESKTOPFILE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

