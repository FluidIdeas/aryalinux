#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.4/net-tools-CVS_20101030-remove_dups-1.patch


NAME=net-tools
VERSION=20101030
URL=http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
SECTION="Networking Programs"
DESCRIPTION="The Net-tools package is a collection of programs for controlling the network subsystem of the Linux kernel."

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


patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&
sed -i '/#include <netinet\/ip.h>/d'  iptunnel.c &&

yes "" | make config &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make update
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

