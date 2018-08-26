#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Gparted is the Gnome Partition Editor, a Gtk 2 GUI for other command line tools that can create, reorganise or delete disk partitions."
SECTION="xsoft"
VERSION=0.31.0
NAME="gparted-gtk3"

#REQ:gtkmm2
#REQ:parted
#OPT:btrfs-progs
#OPT:rarian


cd $SOURCE_DIR

URL=https://github.com/lb90/gparted-gtk3.git
DIRECTORY=gparted-gtk3

whoami > /tmp/currentuser

git clone $URL
cd $DIRECTORY
./autogen.sh --prefix=/usr    \
            --disable-doc    \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/gparted.desktop /usr/share/applications/gparted.desktop.back &&
sed -i 's/Exec=/Exec=sudo -A /'               /usr/share/applications/gparted.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
