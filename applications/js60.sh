#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:autoconf213
#REQ:icu
#REQ:python2
#REQ:which
#REQ:rust
#REQ:zip


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.8.0.tar.bz2


NAME=js60
VERSION=60.8.0
URL=http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.8.0.tar.bz2
SECTION="General Libraries"
DESCRIPTION="JS is Mozilla's JavaScript engine written in C."

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


if ! grep -ri "/opt/rustc/lib" /etc/ld.so.conf &> /dev/null; then
	echo "/opt/rustc/lib" | sudo tee -a /etc/ld.so.conf
	sudo ldconfig
fi

sudo ldconfig
. /etc/profile.d/rustc.sh

mkdir mozjs-build &&
cd    mozjs-build &&

../js/src/configure --prefix=/usr       \
                    --with-intl-api     \
                    --with-system-zlib  \
                    --with-system-icu   \
                    --disable-jemalloc  \
                    --enable-readline   &&
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

