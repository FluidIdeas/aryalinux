#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:nftables
#REQ:python-modules#python-slip
#REQ:docbook
#REQ:iptables
#REQ:libxslt


cd $SOURCE_DIR

wget -nc https://github.com/firewalld/firewalld/releases/download/v0.8.1/firewalld-0.8.1.tar.gz


NAME=firewalld
VERSION=0.8.1
URL=https://github.com/firewalld/firewalld/releases/download/v0.8.1/firewalld-0.8.1.tar.gz
SECTION="Security"
DESCRIPTION="The firewalld package provides a dynamically managed firewall with support for network or firewall zones to define the trust level of network connections or interfaces. It has support for IPv4, IPv6 firewall settings and for ethernet bridges and a separation of runtime and permanent configuration options. It also provides an interface for services or applications to add nftables or iptables and ebtables rules directly."

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


PYTHON=/usr/bin/python3           \
    ./configure --sysconfdir=/etc \
                --without-ipset   &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable firewalld
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

