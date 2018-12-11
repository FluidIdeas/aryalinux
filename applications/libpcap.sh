#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libpcap provides functions forbr3ak user-level packet capture, used in low-level network monitoring.br3ak"
SECTION="basicnet"
VERSION=1.9.0
NAME="libpcap"

#OPT:bluez
#OPT:libnl
#OPT:libusb


cd $SOURCE_DIR

URL=http://www.tcpdump.org/release/libpcap-1.9.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.tcpdump.org/release/libpcap-1.9.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpcap/libpcap-1.9.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libpcap-1.9.0-enable_bluetooth-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libpcap/libpcap-1.9.0-enable_bluetooth-1.patch

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

patch -Np1 -i ../libpcap-1.9.0-enable_bluetooth-1.patch &&
./configure --prefix=/usr &&
make "-j`nproc`" || make


sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
