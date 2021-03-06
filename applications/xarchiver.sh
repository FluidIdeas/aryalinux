#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:gtk3


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/xarchiver-0.5.4-fixes-1.patch


NAME=xarchiver
VERSION=0.5.4
URL=https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2

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

echo $USER > /tmp/currentuser


patch -Np1 -i ../xarchiver-0.5.4-fixes-1.patch &&

./autogen.sh --prefix=/usr               \
             --libexecdir=/usr/lib/xfce4 \
             --docdir=/usr/share/doc/xarchiver-0.5.4 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DOCDIR=/usr/share/doc/xarchiver-0.5.4 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

