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

NAME=libxslt
VERSION=1.1.34
URL=http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
SECTION="General Libraries"
DESCRIPTION="The libxslt package contains XSLT libraries used for extending libxml2 libraries to support XSLT files."


mkdir -pv $NAME
pushd $NAME

wget -nc http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.34.tar.gz


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


sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
./configure --prefix=/usr --disable-static --without-python  &&
make
sed -e 's@http://cdn.docbook.org/release/xsl@https://cdn.docbook.org/release/xsl-nons@' \
    -e 's@\$Date\$@31 October 2019@' -i doc/xsltproc.xml &&
xsltproc/xsltproc --nonet doc/xsltproc.xml -o doc/xsltproc.1
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