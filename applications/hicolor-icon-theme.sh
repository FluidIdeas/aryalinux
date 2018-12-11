#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The hicolor-icon-theme packagebr3ak contains a default fallback theme for implementations of the iconbr3ak theme specification.br3ak"
SECTION="x"
VERSION=0.17
NAME="hicolor-icon-theme"



cd $SOURCE_DIR

URL=https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz

if [ ! -z $URL ]
then
wget -nc https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.17.tar.xz

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
