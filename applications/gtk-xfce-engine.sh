#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GTK Xfce Engine packagebr3ak contains several GTK+ 2 andbr3ak GTK+ 3 themes and libraries neededbr3ak to display them. This is useful for customising the appearance ofbr3ak your Xfce desktop.br3ak"
SECTION="xfce"
VERSION=3.2.0
NAME="gtk-xfce-engine"

#REQ:gtk2
#REC:gtk3


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/gtk-xfce-engine/3.2/gtk-xfce-engine-3.2.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/xfce/gtk-xfce-engine/3.2/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-xfce-engine/gtk-xfce-engine-3.2.0.tar.bz2

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

sed -i 's/\xd6/\xc3\x96/' gtk-3.0/xfce_style_types.h &&
./configure --prefix=/usr --enable-gtk3              &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
