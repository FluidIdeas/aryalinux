#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The gfbgraph package contains abr3ak GObject wrapper for the Facebook Graph API.br3ak"
SECTION="gnome"
VERSION=0.2.3
NAME="gfbgraph"

#REQ:gnome-online-accounts
#REQ:rest
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gfbgraph/gfbgraph-0.2.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make libgfbgraphdocdir=/usr/share/doc/gfbgraph-0.2.3 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
