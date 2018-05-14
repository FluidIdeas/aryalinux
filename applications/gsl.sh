#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNU Scientific Library (GSL) is a numerical library for C andbr3ak C++ programmers. It provides a wide range of mathematical routinesbr3ak such as random number generators, special functions andbr3ak least-squares fitting.br3ak"
SECTION="general"
VERSION=2.4
NAME="gsl"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsl/gsl-2.4.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make


make html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir                   /usr/share/doc/gsl-2.4 &&
cp -R doc/_build/html/* /usr/share/doc/gsl-2.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
