#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The DocBook SGML DTD packagebr3ak contains document type definitions for verification of SGML databr3ak files against the DocBook rule set. These are useful forbr3ak structuring books and software documentation to a standard allowingbr3ak you to utilize transformations already written for that standard.br3ak"
SECTION="pst"
VERSION=4.5
NAME="sgml-dtd"

#REQ:sgml-common
#REQ:unzip


cd $SOURCE_DIR

URL=http://www.docbook.org/sgml/4.5/docbook-4.5.zip

if [ ! -z $URL ]
then
wget -nc http://www.docbook.org/sgml/4.5/docbook-4.5.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-4.5.zip

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

sed -i -e '/ISO 8879/d' \
       -e '/gml/d' docbook.cat



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d /usr/share/sgml/docbook/sgml-dtd-4.5 &&
chown -R root:root . &&
install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-4.5 &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /etc/sgml/sgml-docbook.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /usr/share/sgml/docbook/sgml-dtd-4.5/catalog << "EOF"
 -- Begin Single Major Version catalog changes --
PUBLIC "-//OASIS//DTD DocBook V4.4//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.3//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.2//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.1//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.0//EN" "docbook.dtd"
 -- End Single Major Version catalog changes --
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
