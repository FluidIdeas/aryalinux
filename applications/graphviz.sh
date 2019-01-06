#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:pango
#OPT:cairo
#OPT:x7lib
#OPT:fontconfig
#OPT:gtk2
#OPT:libjpeg
#OPT:libwebp
#OPT:gs
#OPT:librsvg
#OPT:poppler
#OPT:freeglut
#OPT:libglade
#OPT:swig
#OPT:gcc
#OPT:openjdk
#OPT:lua
#OPT:php
#OPT:python2
#OPT:ruby
#OPT:tcl
#OPT:tk

cd $SOURCE_DIR

wget -nc http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/graphviz-2.40.1-qt5-1.patch

NAME=graphviz
VERSION=""
URL=http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz

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

wget -c http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz \
-O graphviz-2.40.1.tar.gz
sed -e '/ruby/s/1\.9/2.4/' -i configure.ac
patch -p1 -i ../graphviz-2.40.1-qt5-1.patch
sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

autoreconf &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ln -v -s /usr/share/graphviz/doc \
/usr/share/doc/graphviz-2.40.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
