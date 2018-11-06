#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Wayland is a project to define abr3ak protocol for a compositor to talk to its clients as well as abr3ak library implementation of the protocol.br3ak"
SECTION="general"
VERSION=1.16.0
NAME="wayland"

#REQ:libxml2
#OPT:doxygen
#OPT:graphviz
#OPT:xmlto
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


cd $SOURCE_DIR

URL=https://wayland.freedesktop.org/releases/wayland-1.16.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://wayland.freedesktop.org/releases/wayland-1.16.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-1.16.0.tar.xz

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

./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
