#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz
wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.10.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/libxml2-2.9.10-security_fixes-1.patch
wget -nc https://www.w3.org/XML/Test/xmlts20130923.tar.gz


NAME=libxml2
VERSION=2.9.10
URL=http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz
SECTION="General Libraries"
DESCRIPTION="The libxml2 package contains libraries and utilities used for parsing XML files."

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


patch -p1 -i ../libxml2-2.9.10-security_fixes-1.patch
sed -i '/if Py/{s/Py/(Py/;s/)/))/}' python/{types.c,libxml.c}
sed -i 's/test.test/#&/' python/tests/tstLastError.py
sed -i 's/ TRUE/ true/' encoding.c
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
tar xf ../xmlts20130923.tar.gz
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd