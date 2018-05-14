#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak JS is Mozilla's JavaScript enginebr3ak written in C.br3ak"
SECTION="general"
VERSION=0
NAME="js38"

#REQ:autoconf213
#REQ:icu
#REQ:nspr
#REQ:python2
#REQ:zip
#OPT:doxygen


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/mozjs/mozjs-38.2.1.rc0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mozjs/mozjs-38.2.1.rc0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/8.2/js38-38.2.1-upstream_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/js38/js38-38.2.1-upstream_fixes-2.patch

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

patch -Np1 -i ../js38-38.2.1-upstream_fixes-2.patch


cd js/src &&
autoconf2.13 &&
./configure --prefix=/usr       \
            --with-intl-api     \
            --with-system-zlib  \
            --with-system-ffi   \
            --with-system-nspr  \
            --with-system-icu   \
            --enable-threadsafe \
            --enable-readline   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
pushd /usr/include/mozjs-38 &&
for link in `find . -type l`; do
    header=`readlink $link`
    rm -f $link
    cp -pv $header $link
    chmod 644 $link
done &&
popd &&
chown -Rv root.root /usr/include/mozjs-38

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
