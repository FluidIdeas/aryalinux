#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/net-tools-CVS_20101030-remove_dups-1.patch

URL=http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&
sed -i '/#include <netinet\/ip.h>/d'  iptunnel.c &&

yes "" | make config &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make update
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
