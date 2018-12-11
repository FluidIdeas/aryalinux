#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libtirpc

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.5.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/rpcbind-1.2.5-vulnerability_fixes-1.patch

URL=https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.5.tar.bz2

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c
patch -Np1 -i ../rpcbind-1.2.5-vulnerability_fixes-1.patch &&

./configure --prefix=/usr       \
            --bindir=/sbin      \
            --sbindir=/sbin     \
            --enable-warmstarts \
            --with-rpcuser=rpc  &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-rpcbind
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
