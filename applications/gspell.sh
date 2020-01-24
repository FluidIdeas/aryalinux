#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:enchant


cd $SOURCE_DIR

wget -nc https://ftp.gnome.org/pub/gnome/sources/gspell/1.8/gspell-1.8.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gspell/1.8/gspell-1.8.1.tar.xz


NAME=gspell
VERSION=1.8.1
URL=https://ftp.gnome.org/pub/gnome/sources/gspell/1.8/gspell-1.8.1.tar.xz
SECTION="General Libraries and Utilities"
DESCRIPTION="The gspell package provides a flexible API to add spell checking to a GTK+ application."

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


./configure --prefix=/usr &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

