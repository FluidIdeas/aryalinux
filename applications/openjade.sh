#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenJade package contains abr3ak DSSSL engine. This is useful for SGML and XML transformations intobr3ak RTF, TeX, SGML and XML.br3ak"
SECTION="pst"
VERSION=1.3.2
NAME="openjade"

#REQ:opensp


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjade/openjade-1.3.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openjade-1.3.2-upstream-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openjade/openjade-1.3.2-upstream-1.patch

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

patch -Np1 -i ../openjade-1.3.2-upstream-1.patch


sed -i -e '/getopts/{N;s#&G#g#;s#do .getopts.pl.;##;}' \
       -e '/use POSIX/ause Getopt::Std;' msggen.pl


export CXXFLAGS="$CXXFLAGS -fno-lifetime-dse"            &&
./configure --prefix=/usr                                \
            --mandir=/usr/share/man                      \
            --enable-http                                \
            --disable-static                             \
            --enable-default-catalog=/etc/sgml/catalog   \
            --enable-default-search-path=/usr/share/sgml \
            --datadir=/usr/share/sgml/openjade-1.3.2   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                                   &&
make install-man                                               &&
ln -v -sf openjade /usr/bin/jade                               &&
ln -v -sf libogrove.so /usr/lib/libgrove.so                    &&
ln -v -sf libospgrove.so /usr/lib/libspgrove.so                &&
ln -v -sf libostyle.so /usr/lib/libstyle.so                    &&
install -v -m644 dsssl/catalog /usr/share/sgml/openjade-1.3.2/ &&
install -v -m644 dsssl/*.{dtd,dsl,sgm}              \
    /usr/share/sgml/openjade-1.3.2                             &&
install-catalog --add /etc/sgml/openjade-1.3.2.cat  \
    /usr/share/sgml/openjade-1.3.2/catalog                     &&
install-catalog --add /etc/sgml/sgml-docbook.cat    \
    /etc/sgml/openjade-1.3.2.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "SYSTEM \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \
    \"/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd\"" >> \
    /usr/share/sgml/openjade-1.3.2/catalog

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
