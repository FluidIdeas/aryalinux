#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Desktop File Utils packagebr3ak contains command line utilities for working with <a class=\"ulink\" br3ak href=\"http://standards.freedesktop.org/desktop-entry-spec/latest/\">Desktopbr3ak entries</a>. These utilities are used by Desktop Environments andbr3ak other applications to manipulate the MIME-types applicationbr3ak databases and help adhere to the Desktop Entry Specification.br3ak"
SECTION="general"
VERSION=0.23
NAME="desktop-file-utils"

#REQ:glib2
#OPT:emacs


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
