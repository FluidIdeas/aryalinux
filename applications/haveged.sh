#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Haveged package contains abr3ak daemon that generates an unpredictable stream of random numbers andbr3ak feeds the /dev/random device.br3ak"
SECTION="postlfs"
VERSION=1.9.2
NAME="haveged"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/haveged/haveged-1.9.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/haveged/haveged-1.9.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/haveged/haveged-1.9.2.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv    /usr/share/doc/haveged-1.9.2 &&
cp -v README /usr/share/doc/haveged-1.9.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-haveged

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
