#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libtirpc

cd $SOURCE_DIR
NAME=autofs
VERSION=5.1.9
URL=https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.9.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.9.tar.xz


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

./configure --prefix=/usr             \
            --with-mapdir=/etc/autofs \
            --with-libtirpc           \
            --with-systemd            \
            --without-openldap        \
            --mandir=/usr/share/man
make
mv /etc/autofs/auto.master /etc/autofs/auto.master.bak
cat > /etc/autofs/auto.master << "EOF"
# Begin /etc/autofs/auto.master

/media/auto  /etc/autofs/auto.misc  --ghost
#/home        /etc/autofs/auto.home

# End /etc/autofs/auto.master
EOF
systemctl enable autofs


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
make install_samples
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd