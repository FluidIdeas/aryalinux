#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:python2
#OPT:icu
#OPT:valgrind

cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz
wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz
wget -nc http://www.w3.org/XML/Test/xmlts20130923.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libxml2-2.9.8-python3_hack-1.patch

URL=http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

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

patch -Np1 -i ../libxml2-2.9.8-python3_hack-1.patch
sed -i '/_PyVerify_fd/,+1d' python/types.c
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
tar xf ../xmlts20130923.tar.gz
systemctl stop httpd.service

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
