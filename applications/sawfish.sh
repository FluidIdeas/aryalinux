#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gdk-pixbuf-xlib
#REQ:rep-gtk
#REQ:which


cd $SOURCE_DIR

wget -nc http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/fetch-kde-framework/sawfish-1.12.0-gcc10_fixes-1.patch


NAME=sawfish
VERSION=1.12.0
URL=http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz
SECTION="Window Managers"
DESCRIPTION="The sawfish package contains a window manager. This is useful for organizing and displaying windows where all window decorations are configurable and all user-interface policy is controlled through the extension language."

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

echo $USER > /tmp/currentuser


patch -Np1 -i ../sawfish-1.12.0-gcc10_fixes-1.patch
./configure --prefix=/usr --with-pango  &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat >> ~/.xinitrc << "EOF"
exec sawfish
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

