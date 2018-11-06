#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak dhcpcd is an implementation of thebr3ak DHCP client specified in RFC2131. A DHCP client is useful forbr3ak connecting your computer to a network which uses DHCP to assignbr3ak network addresses. dhcpcd strives to be a fully featured, yet verybr3ak lightweight DHCP client.br3ak"
SECTION="basicnet"
VERSION=7.0.8
NAME="dhcpcd"

#OPT:llvm


cd $SOURCE_DIR

URL=http://roy.marples.name/downloads/dhcpcd/dhcpcd-7.0.8.tar.xz

if [ ! -z $URL ]
then
wget -nc http://roy.marples.name/downloads/dhcpcd/dhcpcd-7.0.8.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcpcd-7.0.8.tar.xz || wget -nc ftp://roy.marples.name/pub/dhcpcd/dhcpcd-7.0.8.tar.xz

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

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

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
make install-dhcpcd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
