#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LVM2 package is a set of toolsbr3ak that manage logical partitions. It allows spanning of file systemsbr3ak across multiple physical disks and disk partitions and provides forbr3ak dynamic growing or shrinking of logical partitions, mirroring andbr3ak low storage footprint snapshots.br3ak"
SECTION="postlfs"
VERSION=2.2.03.00
NAME="lvm2"

#REQ:libaio
#OPT:mdadm
#OPT:reiserfs
#OPT:valgrind
#OPT:general_which
#OPT:xfsprogs


cd $SOURCE_DIR

URL=https://sourceware.org/pub/lvm2/LVM2.2.03.00.tgz

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/pub/lvm2/LVM2.2.03.00.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.03.00.tgz || wget -nc ftp://sourceware.org/pub/lvm2/LVM2.2.03.00.tgz

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C tools install_dmsetup_dynamic &&
make -C udev  install                 &&
make -C libdm install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
