#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libgudev
#REQ:gobject-introspection
#REQ:libmbim
#REQ:libqmi
#REQ:polkit
#REQ:vala


cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/ModemManager/ModemManager-1.10.4.tar.xz


NAME=modemmanager
VERSION=1.10.4
URL=https://www.freedesktop.org/software/ModemManager/ModemManager-1.10.4.tar.xz
SECTION="System Utilities"
DESCRIPTION="ModemManager provides a unified high level API for communicating with mobile broadband modems, regardless of the protocol used to communicate with the actual device."

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


./configure --prefix=/usr                 \
            --sysconfdir=/etc             \
            --localstatedir=/var          \
            --enable-more-warnings=no     \
            --with-systemd-journal        \
            --with-systemd-suspend-resume \
            --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable ModemManager
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

