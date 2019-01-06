#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cmake
#OPT:freetype2
#OPT:python2
#OPT:harfbuzz

cd $SOURCE_DIR

wget -nc https://github.com/silnrsi/graphite/releases/download/1.3.13/graphite2-1.3.13.tgz

NAME=graphite2
VERSION=""
URL=https://github.com/silnrsi/graphite/releases/download/1.3.13/graphite2-1.3.13.tgz

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

sed -i '/cmptest/d' tests/CMakeLists.txt
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make
make docs

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -d -m755 /usr/share/doc/graphite2-1.3.13 &&

cp -v -f doc/{GTF,manual}.html \
/usr/share/doc/graphite2-1.3.13 &&
cp -v -f doc/{GTF,manual}.pdf \
/usr/share/doc/graphite2-1.3.13
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
