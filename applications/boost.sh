#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Boost provides a set of freebr3ak peer-reviewed portable C++ source libraries. It includes librariesbr3ak for linear algebra, pseudorandom number generation, multithreading,br3ak image processing, regular expressions and unit testing.br3ak"
SECTION="general"
VERSION=1_67_0
NAME="boost"

#REC:general_which
#OPT:icu
#OPT:python2


cd $SOURCE_DIR

URL=https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/boost/boost_1_67_0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/boost/boost_1_67_0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/boost/boost_1_67_0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/boost/boost_1_67_0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/boost/boost_1_67_0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/boost/boost_1_67_0.tar.bz2

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

./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./b2 install threading=multi link=shared

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
