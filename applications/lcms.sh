#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Little CMS library is used bybr3ak other programs to provide color management facilities.br3ak"
SECTION="general"
VERSION=1.19
NAME="lcms"

#OPT:libtiff
#OPT:libjpeg
#OPT:python2
#OPT:swig


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lcms-1.19-cve_2013_4276-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lcms/lcms-1.19-cve_2013_4276-1.patch

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

patch -Np1 -i ../lcms-1.19-cve_2013_4276-1.patch &&
./configure --prefix=/usr --disable-static       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/lcms-1.19 &&
install -v -m644    README.1ST doc/* \
                    /usr/share/doc/lcms-1.19

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
