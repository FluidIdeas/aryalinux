#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ldns is a fast DNS library withbr3ak the goal to simplify DNS programming and to allow developers tobr3ak easily create software conforming to current RFCs and Internetbr3ak drafts. This packages also includes the <span class=\"command\"><strong>drill</strong> tool.br3ak"
SECTION="basicnet"
VERSION=1.7.0
NAME="ldns"

#OPT:make-ca
#OPT:libpcap
#OPT:python2
#OPT:swig
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.nlnetlabs.nl/downloads/ldns/ldns-1.7.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.nlnetlabs.nl/downloads/ldns/ldns-1.7.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.7.0.tar.gz

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

./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-drill            &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
