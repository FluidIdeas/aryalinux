#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ModemManager provides a unifiedbr3ak high level API for communicating with mobile broadband modems,br3ak regardless of the protocol used to communicate with the actualbr3ak device.br3ak"
SECTION="general"
VERSION=1.6.12
NAME="ModemManager"

#REQ:libgudev
#REC:gobject-introspection
#REC:libmbim
#REC:libqmi
#REC:polkit
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/ModemManager/ModemManager-1.6.12.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.12.tar.xz

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

./configure --prefix=/usr                 \
            --sysconfdir=/etc             \
            --localstatedir=/var          \
            --enable-more-warnings=no     \
            --with-suspend-resume=systemd \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable ModemManager

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
