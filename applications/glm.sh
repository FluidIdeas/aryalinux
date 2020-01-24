#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake


cd $SOURCE_DIR

wget -nc https://github.com/g-truc/glm/archive/0.9.9.5/glm-0.9.9.5.tar.gz


NAME=glm
VERSION=0.9.9.5
URL=https://github.com/g-truc/glm/archive/0.9.9.5/glm-0.9.9.5.tar.gz
SECTION="General Libraries and Utilities"
DESCRIPTION="OpenGL Mathematics (GLM) is a header-only C++ mathematics library for graphics software based on the OpenGL Shading Language (GLSL) specifications. An extension system provides extended capabilities such as matrix transformations and quaternions."

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


mkdir build &&
cd build    &&

cmake -DCMAKE_INSTALL_PREFIX=/usr   \
      -DCMAKE_INSTALL_LIBDIR=lib .. &&
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

