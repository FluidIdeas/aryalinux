#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/graphviz-2.40.1-qt5-1.patch


NAME=graphviz
VERSION=
URL=http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz

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


sed -e '/ruby/s/1\.9/2.6/' -i configure.ac
patch -p1 -i ../graphviz-2.40.1-qt5-1.patch
sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

autoreconf                &&
./configure --prefix=/usr &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -v -s /usr/share/graphviz/doc \
         /usr/share/doc/graphviz-2.40.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

