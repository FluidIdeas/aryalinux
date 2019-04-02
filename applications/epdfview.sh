#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk2
#REQ:poppler
#REC:desktop-file-utils
#REC:hicolor-icon-theme

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/blfs/epdfview/epdfview-0.1.8.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/epdfview-0.1.8-fixes-2.patch

NAME=epdfview
VERSION=0.1.8
URL=http://anduin.linuxfromscratch.org/blfs/epdfview/epdfview-0.1.8.tar.bz2

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

patch -Np1 -i ../epdfview-0.1.8-fixes-2.patch &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
for size in 24 32 48; do
ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
/usr/share/icons/hicolor/${size}x${size}/apps
done &&
unset size &&

update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
