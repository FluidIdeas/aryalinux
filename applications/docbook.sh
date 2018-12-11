#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
DESCRIPTION="br3ak The DocBook XML DTD-4.5 packagebr3ak contains document type definitions for verification of XML databr3ak files against the DocBook rule set. These are useful forbr3ak structuring books and software documentation to a standard allowingbr3ak you to utilize transformations already written for that standard.br3ak"
SECTION="pst"
VERSION=4.5
NAME="docbook"

#REQ:libxml2
#REQ:sgml-common
#REQ:unzip


cd $SOURCE_DIR

URL=http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip

if [ ! -z $URL ]
then
wget -nc http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xml/docbook-xml-4.5.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5 &&
install -v -d -m755 /etc/xml &&
chown -R root:root . &&
cp -v -af docbook.cat *.dtd ent/ *.mod \
    /usr/share/xml/docbook/xml-dtd-4.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ ! -e /etc/xml/docbook ]; then
    xmlcatalog --noout --create /etc/xml/docbook
fi &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for DTDVERSION in 4.1.2 4.2 4.3 4.4
do
  xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
    /etc/xml/docbook
  xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
  xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
