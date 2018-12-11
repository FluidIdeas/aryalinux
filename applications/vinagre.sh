#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Vinagre is a VNC client for thebr3ak GNOME Desktop.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="vinagre"

#REQ:gtk-vnc
#REQ:itstool
#REQ:libsecret
#REC:telepathy-glib
#REC:vala
#REC:vte
#OPT:avahi


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vinagre/vinagre-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz

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

./configure --prefix=/usr \
            --enable-compile-warnings=minimum &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
