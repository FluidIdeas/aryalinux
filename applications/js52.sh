#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:autoconf213
#REQ:icu
#REQ:nspr
#REQ:python2
#REQ:x7lib
#REQ:zip
#OPT:doxygen

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz
wget -nc ftp://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz

NAME=js52
VERSION=52.2.1gnome1
URL=http://ftp.gnome.org/pub/gnome/teams/releng/tarballs-needing-help/mozjs/mozjs-52.2.1gnome1.tar.gz

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

cd js/src &&

./configure --prefix=/usr       \
            --with-intl-api     \
            --with-system-zlib  \
            --with-system-nspr  \
            --with-system-icu   \
            --enable-threadsafe \
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
