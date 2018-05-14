#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Whois is a client-side applicationbr3ak which queries the whois directory service for informationbr3ak pertaining to a particular domain name. This package will installbr3ak two programs by default: <span class=\"command\"><strong>whois</strong> and <span class=\"command\"><strong>mkpasswd</strong>. The <span class=\"command\"><strong>mkpasswd</strong> command is alsobr3ak installed by the <a class=\"xref\" href=\"../general/expect.html\" br3ak title=\"Expect-5.45.4\">Expect-5.45.4</a> package.br3ak"
SECTION="basicnet"
VERSION=5.2.20
NAME="whois"

#OPT:libidn


cd $SOURCE_DIR

URL=https://github.com/rfc1036/whois/archive/v5.2.20/whois-5.2.20.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/rfc1036/whois/archive/v5.2.20/whois-5.2.20.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/whois/whois-5.2.20.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/whois/whois-5.2.20.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois-5.2.20.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois-5.2.20.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois-5.2.20.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois-5.2.20.tar.gz

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

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install-whois
make prefix=/usr install-mkpasswd
make prefix=/usr install-pos

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
