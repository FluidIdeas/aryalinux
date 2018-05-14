#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Unbound is a validating,br3ak recursive, and caching DNS resolver. It is designed as a set ofbr3ak modular components that incorporate modern features, such asbr3ak enhanced security (DNSSEC) validation, Internet Protocol Version 6br3ak (IPv6), and a client resolver library API as an integral part ofbr3ak the architecture.br3ak"
SECTION="server"
VERSION=1.7.0
NAME="unbound"

#OPT:libevent
#OPT:nettle
#OPT:python2
#OPT:swig
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.unbound.net/downloads/unbound-1.7.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.unbound.net/downloads/unbound-1.7.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.7.0.tar.gz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 88 unbound &&
useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 \
        -g unbound -s /bin/false unbound

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-pidfile=/run/unbound.pid &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/sbin/unbound-host /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "nameserver 127.0.0.1" > /etc/resolv.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/request /i\supersede domain-name-servers 127.0.0.1;' \
       /etc/dhcp/dhclient.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
unbound-anchor

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
make install-unbound

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
