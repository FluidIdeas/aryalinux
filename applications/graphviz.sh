#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=graphviz
VERSION=7.1.0
URL=https://gitlab.com/graphviz/graphviz/-/archive/7.1.0/graphviz-7.1.0.tar.bz2
SECTION="General Utilities"
DESCRIPTION="The Graphviz package contains graph visualization software. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks. Graphviz has several main graph layout programs. It also has web and interactive graphical interfaces, auxiliary tools, libraries, and language bindings."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.com/graphviz/graphviz/-/archive/7.1.0/graphviz-7.1.0.tar.bz2


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


sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

./autogen.sh              &&
./configure --prefix=/usr \
            --docdir=/usr/share/doc/graphviz-7.1.0
sed -i "s/0/$(date +%Y%m%d)/" builddate.h
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