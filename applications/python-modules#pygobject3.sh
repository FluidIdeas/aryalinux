#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:python-modules#pycairo
#REQ:python2
#REQ:python-modules#pycairo
#REQ:python-modules#pycairo2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.34/pygobject-3.34.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.34/pygobject-3.34.0.tar.xz


NAME=python-modules#pygobject3
VERSION=3.34.0
URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/3.34/pygobject-3.34.0.tar.xz
SECTION="Others"

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

mkdir python2                           &&
pushd python2                           &&
meson --prefix=/usr -Dpython=python2 .. &&
ninja                                   &&
popd
mkdir python3                           &&
pushd python3                           &&
meson --prefix=/usr -Dpython=python3 .. &&
ninja                                   &&
popd
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja -C python2 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja -C python3 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

