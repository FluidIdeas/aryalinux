#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXDE Icon Theme packagebr3ak contains nuoveXT 2.2 Icon Theme for LXDE.br3ak"
SECTION="x"
VERSION=0.5.1
NAME="lxde-icon-theme"

#OPT:gtk2
#OPT:gtk3


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxde-icon-theme/lxde-icon-theme-0.5.1.tar.xz

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

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
