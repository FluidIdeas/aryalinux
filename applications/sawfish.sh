#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The sawfish package contains abr3ak window manager. This is useful for organizing and displayingbr3ak windows where all window decorations are configurable and allbr3ak user-interface policy is controlled through the extension language.br3ak"
SECTION="x"
VERSION=1.12.0
NAME="sawfish"

#REQ:rep-gtk
#REQ:general_which


cd $SOURCE_DIR

URL=http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz

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

./configure --prefix=/usr --with-pango  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.xinitrc << "EOF"
exec sawfish
EOF




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
