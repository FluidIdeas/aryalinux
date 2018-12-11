#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libaio
#OPT:mdadm
#OPT:reiserfs
#OPT:valgrind
#OPT:which
#OPT:xfsprogs

cd $SOURCE_DIR

wget -nc https://sourceware.org/pub/lvm2/LVM2.2.03.01.tgz
wget -nc ftp://sourceware.org/pub/lvm2/LVM2.2.03.01.tgz

URL=https://sourceware.org/pub/lvm2/LVM2.2.03.01.tgz

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

SAVEPATH=$PATH                  &&
PATH=$PATH:/sbin:/usr/sbin      &&
./configure --prefix=/usr       \
            --exec-prefix=      \
            --with-confdir=/etc \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  &&
make                            &&
PATH=$SAVEPATH                  &&
unset SAVEPATH

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C tools install_dmsetup_dynamic &&
make -C udev  install                 &&
make -C libdm install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

--with-thin-check=    \
     --with-thin-dump=     \
     --with-thin-repair=   \
     --with-thin-restore=  \
     --with-cache-check=   \
     --with-cache-dump=    \
     --with-cache-repair=  \
     --with-cache-restore= \

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
