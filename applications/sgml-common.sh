#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The SGML Common package containsbr3ak <span class=\"command\"><strong>install-catalog</strong>. Thisbr3ak is useful for creating and maintaining centralized SGML catalogs.br3ak"
SECTION="pst"
VERSION=0.6.3
NAME="sgml-common"



cd $SOURCE_DIR

URL=https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sgml-common/sgml-common-0.6.3.tgz || wget -nc ftp://sourceware.org/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/sgml-common-0.6.3-manpage-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/sgml-common/sgml-common-0.6.3-manpage-1.patch

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

patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i


./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install &&
install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


install-catalog --remove /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --remove /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
