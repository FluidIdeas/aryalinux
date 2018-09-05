#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libxml2 package containsbr3ak libraries and utilities used for parsing XML files.br3ak"
SECTION="general"
VERSION=2.9.8
NAME="libxml2"

#OPT:python2
#OPT:icu
#OPT:valgrind


cd $SOURCE_DIR

URL=http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz
wget -nc http://www.w3.org/XML/Test/xmlts20130923.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libxml2-2.9.8-python3_hack-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libxml2/libxml2-2.9.8-python3_hack-1.patch

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

patch -Np1 -i ../libxml2-2.9.8-python3_hack-1.patch


sed -i '/_PyVerify_fd/,+1d' python/types.c


./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make "-j`nproc`" || make


tar xf ../xmlts20130923.tar.gz


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
