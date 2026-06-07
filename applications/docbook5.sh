#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libarchive

cd $SOURCE_DIR
NAME=docbook5
VERSION=5.0
URL=https://archive.docbook.org/xml/5.0/docbook-5.0.zip
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.docbook.org/xml/5.0/docbook-5.0.zip


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

cp -rv catalog.xml dtd rng sch xsd /usr/share/xml/docbook/xml-5.0
if [ ! -e /etc/xml/catalog ]; then
    install -v -d -m755 /etc/xml
xmlcatalog --noout --create /etc/xml/catalog
fi
xmlcatalog --noout --add "delegatePublic"             \
  "-//OASIS//DTD DocBook XML 5.0//EN                " \
  "file:///usr/share/xml/docbook/xml-5.0/catalog.xml" \
  /etc/xml/catalog
xmlcatalog --noout --add "delegateSystem"             \
  "http://docbook.org/xml/5.0/dtd/"                   \
  "file:///usr/share/xml/docbook/xml-5.0/catalog.xml" \
  /etc/xml/catalog
xmlcatalog --noout --add "delegateURI"                \
  "http://docbook.org/xml/5.0"                        \
  "file:///usr/share/xml/docbook/xml-5.0/catalog.xml" \
  /etc/xml/catalog


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /usr/share/xml/docbook/xml-5.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd