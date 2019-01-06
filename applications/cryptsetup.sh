#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:json-c
#REQ:libgcrypt
#REQ:lvm2
#REQ:popt
#OPT:libpwquality
#OPT:python2

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/cryptsetup-2.0.6.tar.xz

NAME=cryptsetup
VERSION=2.0.6
URL=https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/cryptsetup-2.0.6.tar.xz

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

./configure --prefix=/usr \
            --with-crypto_backend=openssl &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
