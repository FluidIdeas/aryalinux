#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ePDFView is a free standalonebr3ak lightweight PDF document viewer using Poppler and GTK+ libraries. It is a good replacement forbr3ak Evince as it does not rely uponbr3ak GNOME libraries.br3ak"
SECTION="pst"
VERSION=0.1.8
NAME="epdfview"

#REQ:gtk2
#REQ:poppler
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#OPT:cups


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/epdfview/epdfview-0.1.8.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/epdfview-0.1.8-fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/epdfview/epdfview-0.1.8-fixes-2.patch

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

patch -Np1 -i ../epdfview-0.1.8-fixes-2.patch &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for size in 24 32 48; do
  ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
          /usr/share/icons/hicolor/${size}x${size}/apps
done &&
unset size &&
update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
