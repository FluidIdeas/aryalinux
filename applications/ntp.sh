#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ntp package contains a clientbr3ak and server to keep the time synchronized between various computersbr3ak over a network. This package is the official referencebr3ak implementation of the NTP protocol.br3ak"
SECTION="basicnet"
VERSION=12
NAME="ntp"

#REQ:perl-modules#perl-io-socket-ssl
#OPT:libcap
#OPT:libevent


cd $SOURCE_DIR

URL=https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ntp/ntp-4.2.8p12.tar.gz

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
groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -e 's/"(\\S+)"/"?([^\\s"]+)"?/' \
    -i scripts/update-leap/update-leap.in


./configure CFLAGS="-O2 -g -fPIC" \
            --prefix=/usr         \
            --bindir=/usr/sbin    \
            --sysconfdir=/etc     \
            --enable-linuxcaps    \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p12 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -o ntp -g ntp -d /var/lib/ntp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/ntp.conf << "EOF"
# Asia
server 0.asia.pool.ntp.org
# Australia
server 0.oceania.pool.ntp.org
# Europe
server 0.europe.pool.ntp.org
# North America
server 0.north-america.pool.ntp.org
# South America
server 2.south-america.pool.ntp.org
driftfile /var/lib/ntp/ntp.drift
pidfile /var/run/ntpd.pid
leapfile /etc/ntp.leapseconds
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ntp.conf << "EOF"
# Security session
restrict default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict ::1
EOF

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
make install-ntpd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
