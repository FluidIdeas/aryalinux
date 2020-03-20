#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libexif
#REQ:libtiff
#REQ:libjpeg
#REQ:libpng
#REQ:giflib


cd $SOURCE_DIR

wget -nc https://www.windowmaker.org/pub/source/release/WindowMaker-0.95.8.tar.gz


NAME=window-maker
VERSION=0.95.8
URL=https://www.windowmaker.org/pub/source/release/WindowMaker-0.95.8.tar.gz
SECTION="Window Managers"
DESCRIPTION="Window Maker is an X11 window manager that reproduces, in every way possible, the elegant look and feel of the NeXTSTEP user interface."

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
touch /usr/share/xsessions/wmaker.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

echo exec wmaker > ~/.xinitrc

cat > /usr/share/xsessions/wmaker.desktop <<"ENDOFDESKTOPFILE"
[Desktop Entry]
Encoding=UTF-8
Name=Window Maker
Comment=The Window Maker window manager
Type=XSession
Exec=/usr/bin/wmaker
TryExec=/usr/bin/wmaker
ENDOFDESKTOPFILE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

