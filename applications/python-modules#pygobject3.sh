#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:python-modules#pycairo
#REQ:python-modules#pycairo2


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/pygobject/3.40/pygobject-3.40.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/pygobject/3.40/pygobject-3.40.1.tar.xz


NAME=python-modules#pygobject3
VERSION=3.40.1
URL=https://download.gnome.org/sources/pygobject/3.40/pygobject-3.40.1.tar.xz
SECTION="Others"

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


echo $USER > /tmp/currentuser

mv -v tests/test_gdbus.py{,.nouse}
mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

