#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libblockdev is a C library supporting GObject Introspection forbr3ak manipulation of block devices. It has a plugin-based architecturebr3ak where each technology (like LVM, Btrfs, MD RAID, Swap,...) isbr3ak implemented in a separate plugin, possibly with multiplebr3ak implementations (e.g. using LVM CLI or the new LVM DBus API).br3ak"
SECTION="general"
VERSION=2.20
NAME="libblockdev"

#REQ:gobject-introspection
#REQ:libbytesize
#REQ:parted
#REQ:volume_key
#REQ:yaml
#OPT:btrfs-progs
#OPT:gtk-doc
#OPT:mdadm


cd $SOURCE_DIR

URL=https://github.com/storaged-project/libblockdev/releases/download/2.20-1/libblockdev-2.20.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/storaged-project/libblockdev/releases/download/2.20-1/libblockdev-2.20.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libblockdev/libblockdev-2.20.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-python3    \
            --without-gtk-doc \
            --without-nvdimm  \
            --without-dm      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
