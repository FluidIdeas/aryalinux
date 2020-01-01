#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:poppler
#REQ:desktop-file-utils
#REQ:hicolor-icon-theme


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/epdfview/epdfview-0.1.8.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/epdfview-0.1.8-fixes-2.patch


NAME=epdfview
VERSION=0.1.8


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

patch -Np1 -i $SOURCE_DIR/epdfview-0.1.8-fixes-2.patch &&
./configure --prefix=/usr &&
make
sudo make install
for size in 24 32 48; do
  sudo ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
          /usr/share/icons/hicolor/${size}x${size}/apps
done &&
unset size &&

sudo update-desktop-database &&
sudo gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

