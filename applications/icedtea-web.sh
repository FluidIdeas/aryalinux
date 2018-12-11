#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The IcedTea-Web package containsbr3ak both a Java browser plugin, and abr3ak new webstart implementation, licensed under GPLV3.br3ak"
SECTION="xsoft"
VERSION=1.7.1
NAME="icedtea-web"

#REQ:npapi-sdk
#REQ:openjdk
#REQ:java
#REQ:ojdk-conf
#REQ:epiphany
#REQ:midori
#REQ:seamonkey
#OPT:libxslt
#OPT:mercurial


cd $SOURCE_DIR

URL=http://icedtea.wildebeest.org/download/source/icedtea-web-1.7.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://icedtea.wildebeest.org/download/source/icedtea-web-1.7.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.1.tar.gz

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

./configure --prefix=${JAVA_HOME}/jre    \
            --with-jdk-home=${JAVA_HOME} \
            --disable-docs               \
            --mandir=${JAVA_HOME}/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -Dm0644 itweb-settings.desktop /usr/share/applications/itweb-settings.desktop &&
install -v -Dm0644 javaws.png /usr/share/pixmaps/javaws.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -dm755 /usr/lib/mozilla/plugins &&
ln -s ${JAVA_HOME}/jre/lib/IcedTeaPlugin.so /usr/lib/mozilla/plugins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
