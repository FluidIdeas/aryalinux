#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.isc.org/isc/bind9/9.14.5/bind-9.14.5.tar.gz


NAME=bind-utils
VERSION=9.14.5
URL=ftp://ftp.isc.org/isc/bind9/9.14.5/bind-9.14.5.tar.gz
SECTION="Networking Utilities"
DESCRIPTION="BIND Utilities is not a separate package, it is a collection of the client side programs that are included with BIND-9.14.5. The BIND package includes the client side programs nslookup, dig and host. If you install BIND server, these programs will be installed automatically. This section is for those users who don't need the complete BIND server, but need these client side applications."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


./configure --prefix=/usr --without-python &&
make -C lib/dns    &&
make -C lib/isc    &&
make -C lib/bind9  &&
make -C lib/isccfg &&
make -C lib/irs    &&
make -C bin/dig
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C bin/dig install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

