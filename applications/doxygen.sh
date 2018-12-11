#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#OPT:graphviz
#OPT:gs
#OPT:libxml2
#OPT:llvm
#OPT:python2
#OPT:qt5
#OPT:texlive
#OPT:tl-installer
#OPT:xapian

cd $SOURCE_DIR

wget -nc http://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz
wget -nc ftp://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz

NAME=doxygen
VERSION=1.8.14.src
URL=http://ftp.stack.nl/pub/doxygen/doxygen-1.8.14.src.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir -v build &&
cd       build &&

cmake -G "Unix Makefiles"         \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -Wno-dev .. &&

make
cmake -DDOC_INSTALL_DIR=share/doc/doxygen-1.8.14 -Dbuild_doc=ON .. &&

make docs

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -vm644 ../doc/*.1 /usr/share/man/man1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
