#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libsigc


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glibmm/2.60/glibmm-2.60.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glibmm/2.60/glibmm-2.60.0.tar.xz


NAME=glibmm
VERSION=2.60.0
URL=http://ftp.gnome.org/pub/gnome/sources/glibmm/2.60/glibmm-2.60.0.tar.xz
SECTION="Miscellaneous"

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


sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.60.0/' \
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

