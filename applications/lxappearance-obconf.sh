#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXAppearance OBconf packagebr3ak contains a plugin for LXAppearancebr3ak to configure OpenBox.br3ak"
SECTION="lxde"
VERSION=0.2.3
NAME="lxappearance-obconf"

#REQ:lxappearance
#REQ:openbox


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxde/lxappearance-obconf-0.2.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxde/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz

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
