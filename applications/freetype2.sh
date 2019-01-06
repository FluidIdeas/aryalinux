#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:harfbuzz
#REC:freetype2
#REC:libpng
#REC:which

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/freetype/freetype-2.9.1.tar.bz2
wget -nc https://downloads.sourceforge.net/freetype/freetype-doc-2.9.1.tar.bz2

NAME=freetype2
VERSION=2.9.1.
URL=https://downloads.sourceforge.net/freetype/freetype-2.9.1.tar.bz2

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

tar -xf ../freetype-doc-2.9.1.tar.bz2 --strip-components=2 -C docs
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
-i include/freetype/config/ftoption.h &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
cp builds/unix/freetype-config /usr/bin
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/doc/freetype-2.9.1 &&
cp -v -R docs/* /usr/share/doc/freetype-2.9.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
