#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak HexChat is an IRC chat program. Itbr3ak allows you to join multiple IRC channels (chat rooms) at the samebr3ak time, talk publicly, have private one-on-one conversations, etc.br3ak File transfers are also possible.br3ak"
SECTION="xsoft"
VERSION=2.14.2
NAME="hexchat"

#REQ:glib2
#REC:gtk2
#REC:lua
#OPT:dbus-glib
#OPT:iso-codes
#OPT:libcanberra
#OPT:libnotify
#OPT:pciutils


cd $SOURCE_DIR

URL=https://dl.hexchat.net/hexchat/hexchat-2.14.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://dl.hexchat.net/hexchat/hexchat-2.14.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.14.2.tar.xz

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

mkdir build &&
cd    build &&
meson --prefix=/usr -Dwith-libproxy=false -Dwith-lua=lua .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
