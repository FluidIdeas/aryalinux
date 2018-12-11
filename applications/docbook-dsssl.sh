#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
DESCRIPTION="br3ak The DocBook DSSSL Stylesheetsbr3ak package contains DSSSL stylesheets. These are used by OpenJade or other tools to transform SGML andbr3ak XML DocBook files.br3ak"
SECTION="pst"
VERSION=1.79
NAME="docbook-dsssl"

#REQ:sgml-common
#REQ:sgml-dtd-3
#REQ:sgml-dtd
#REQ:opensp
#REQ:openjade


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-1.79.tar.bz2 || wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/docbook-dsssl-1.79.tar.bz2
wget -nc https://downloads.sourceforge.net/docbook/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-dsssl/docbook-dsssl-doc-1.79.tar.bz2

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

tar -xf ../docbook-dsssl-doc-1.79.tar.bz2 --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 bin/collateindex.pl /usr/bin                      &&
install -v -m644 bin/collateindex.pl.1 /usr/share/man/man1         &&
install -v -d -m755 /usr/share/sgml/docbook/dsssl-stylesheets-1.79 &&
cp -v -R * /usr/share/sgml/docbook/dsssl-stylesheets-1.79          &&
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/catalog         &&
install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/common/catalog  &&
install-catalog --add /etc/sgml/sgml-docbook.cat              \
    /etc/sgml/dsssl-docbook-stylesheets.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /usr/share/sgml/docbook/dsssl-stylesheets-1.79/doc/testdata

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t rtf -d jtest.dsl jtest.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
onsgmls -sv test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t rtf \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/print/docbook.dsl \
    test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
openjade -t sgml \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/html/docbook.dsl \
    test.sgm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm jtest.rtf test.rtf c1.htm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
