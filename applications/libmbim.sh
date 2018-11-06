#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libmbim package contains abr3ak GLib-based library for talking to WWAN modems and devices whichbr3ak speak the Mobile Interface Broadband Model (MBIM) protocol.br3ak"
SECTION="general"
VERSION=1.16.2
NAME="libmbim"

#REQ:libgudev
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/libmbim/libmbim-1.16.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/libmbim/libmbim-1.16.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmbim/libmbim-1.16.2.tar.xz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
