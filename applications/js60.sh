#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:autoconf213
#REQ:icu
#REQ:nspr
#REQ:python2
#REQ:x7lib
#REQ:yasm
#REQ:zip
#OPT:doxygen

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2

NAME=js60
VERSION=60.1.0.
URL=http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-60.1.0.tar.bz2

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

mkdir mozjs-build &&
cd mozjs-build &&

../js/src/configure --prefix=/usr       \
            --with-intl-api     \
            --with-system-zlib  \
            --with-system-nspr  \
            --with-system-icu   \
            --disable-jemalloc  \
            --enable-readline   &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
