#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The AccountsService packagebr3ak provides a set of D-Bus interfacesbr3ak for querying and manipulating user account information and anbr3ak implementation of those interfaces based on the usermod(8),br3ak useradd(8) and userdel(8) commands.br3ak"
SECTION="general"
VERSION=0.6.54
NAME="accountsservice"

#REQ:libgcrypt
#REQ:polkit
#REC:gobject-introspection
#REC:systemd
#OPT:gtk-doc
#OPT:xmlto


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/accountsservice/accountsservice-0.6.54.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.54.tar.xz

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

meson --prefix=/usr            \
            -Dadmin_group=adm  \
            -Dsystemd=true     \
            .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable accounts-daemon

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
