#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Nmap is a utility for networkbr3ak exploration and security auditing. It supports ping scanning, portbr3ak scanning and TCP/IP fingerprinting.br3ak"
SECTION="basicnet"
VERSION=7.70
NAME="nmap"

#REC:libpcap
#REC:pcre
#REC:liblinear
#OPT:python-modules#pygtk
#OPT:python2
#OPT:subversion


cd $SOURCE_DIR

URL=http://nmap.org/dist/nmap-7.70.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://nmap.org/dist/nmap-7.70.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nmap/nmap-7.70.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nmap/nmap-7.70.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.70.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.70.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.70.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.70.tar.bz2

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

./configure --prefix=/usr --with-liblua=included &&
make "-j`nproc`" || make


sed -i 's/lib./lib/' zenmap/test/run_tests.py



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
