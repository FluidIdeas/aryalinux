#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxml2
#REQ:docbook
#REQ:docbook-xsl


cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz
wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.33.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/libxslt-1.1.33-security_fix-1.patch


NAME=libxslt
VERSION=1.1.33
URL=http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz
SECTION="Miscellaneous"

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


patch -Np1 -i ../libxslt-1.1.33-security_fix-1.patch
sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
./configure --prefix=/usr --disable-static                   &&
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

