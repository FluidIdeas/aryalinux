#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:sgml-common
#REQ:docbook-3.1-dtd
#REQ:opensp

cd $SOURCE_DIR
NAME=docbook-dsssl
VERSION=1.79
URL=https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2


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

tar -xf ../docbook-dsssl-doc-1.79.tar.bz2 --strip-components=1
cp -v -R * /usr/share/sgml/docbook/dsssl-stylesheets-1.79
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/catalog
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/common/catalog
install-catalog --add /etc/sgml/sgml-docbook.cat              \
    /etc/sgml/dsssl-docbook-stylesheets.cat
cd /usr/share/sgml/docbook/dsssl-stylesheets-1.79/doc/testdata
openjade -t rtf -d jtest.dsl jtest.sgm
onsgmls -sv test.sgm
openjade -t rtf \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/print/docbook.dsl \
    test.sgm
openjade -t sgml \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/html/docbook.dsl \
    test.sgm
rm jtest.rtf test.rtf c1.htm


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 bin/collateindex.pl /usr/bin
install -v -m644 bin/collateindex.pl.1 /usr/share/man/man1
install -v -d -m755 /usr/share/sgml/docbook/dsssl-stylesheets-1.79
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd