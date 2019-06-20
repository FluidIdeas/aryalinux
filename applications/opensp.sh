#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:sgml-common


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz


NAME=opensp
VERSION=1.5.2
URL=https://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz

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


sed -i 's/32,/253,/' lib/Syntax.cxx &&
sed -i 's/LITLEN          240 /LITLEN          8092/' \
    unicode/{gensyntax.pl,unicode.syn} &&

./configure --prefix=/usr                              \
            --disable-static                           \
            --disable-doc-build                        \
            --enable-default-catalog=/etc/sgml/catalog \
            --enable-http                              \
            --enable-default-search-path=/usr/share/sgml &&

make pkgdatadir=/usr/share/sgml/OpenSP-1.5.2
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make pkgdatadir=/usr/share/sgml/OpenSP-1.5.2 \
     docdir=/usr/share/doc/OpenSP-1.5.2      \
     install &&

ln -v -sf onsgmls   /usr/bin/nsgmls   &&
ln -v -sf osgmlnorm /usr/bin/sgmlnorm &&
ln -v -sf ospam     /usr/bin/spam     &&
ln -v -sf ospcat    /usr/bin/spcat    &&
ln -v -sf ospent    /usr/bin/spent    &&
ln -v -sf osx       /usr/bin/sx       &&
ln -v -sf osx       /usr/bin/sgml2xml &&
ln -v -sf libosp.so /usr/lib/libsp.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

