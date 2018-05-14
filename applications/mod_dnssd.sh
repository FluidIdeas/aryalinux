#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The mod_dnssd package is anbr3ak Apache HTTPD module which addsbr3ak Zeroconf support via DNS-SD using Avahi. This allows Apache to advertise itself and the websitesbr3ak available to clients compatible with the protocol.br3ak"
SECTION="basicnet"
VERSION=0.6
NAME="mod_dnssd"

#REQ:apache
#REQ:avahi
#OPT:lynx


cd $SOURCE_DIR

URL=http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz

if [ ! -z $URL ]
then
wget -nc http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz

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

sed -i 's/unixd_setup_child/ap_&/' src/mod_dnssd.c &&
./configure --prefix=/usr \
            --disable-lynx &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
sed -i 's| usr| /usr|' /etc/httpd/httpd.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
