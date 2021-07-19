#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:atkmm
#REQ:gtk2
#REQ:pangomm


cd $SOURCE_DIR

NAME=gtkmm2
VERSION=2.24.5
URL=https://mirror.umd.edu/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz
SECTION="X Libraries"
DESCRIPTION="The Gtkmm package provides a C++ interface to GTK+ 2. It can be installed alongside Gtkmm-3.24.4 (the GTK+ 3 version) with no namespace conflicts."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://mirror.umd.edu/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz


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


sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-2.24.5/' \
    -i docs/Makefile.in
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

popd