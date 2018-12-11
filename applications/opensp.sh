#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenSP package contains abr3ak C++ library for using SGML/XMLbr3ak files. This is useful for validating, parsing and manipulating SGMLbr3ak and XML documents.br3ak"
SECTION="pst"
VERSION=1.5.2
NAME="opensp"

#REQ:sgml-common
#OPT:xmlto


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/OpenSP/OpenSP-1.5.2.tar.gz

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
