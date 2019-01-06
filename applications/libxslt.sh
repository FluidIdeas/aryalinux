#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libxml2
#REC:docbook
#REC:docbook-xsl
#OPT:libgcrypt
#OPT:libxml2py2

cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz
wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.32.tar.gz

NAME=libxslt
VERSION=1.1.32
URL=http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz

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

sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
