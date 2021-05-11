#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:exo
#REQ:garcon
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REQ:libcanberra
#REQ:libnotify
#REQ:libxklavier


cd $SOURCE_DIR

wget -nc https://archive.xfce.org/src/xfce/xfce4-settings/4.16/xfce4-settings-4.16.1.tar.bz2


NAME=xfce4-settings
VERSION=4.16.1
URL=https://archive.xfce.org/src/xfce/xfce4-settings/4.16/xfce4-settings-4.16.1.tar.bz2
SECTION="Xfce Desktop"
DESCRIPTION="The Xfce4 Settings package contains a collection of programs that are useful for adjusting your Xfce preferences."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

