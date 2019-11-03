#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fuse2


cd $SOURCE_DIR

wget -nc https://github.com/ostreedev/ostree/releases/download/v2019.4/libostree-2019.4.tar.xz


NAME=libostree
VERSION=2019.4
URL=https://github.com/ostreedev/ostree/releases/download/v2019.4/libostree-2019.4.tar.xz

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

./configure --prefix=/usr    \
            --disable-static \
            --exec-prefix=/  &&
make &&
make DESTDIR=$PWD/Dest install

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm755 Dest/lib/libfuse.so.2.9.9 /lib                  &&
install -vm755 Dest/lib/libulockmgr.so.1.0.1 /lib                 &&
ln -sfv ../../lib/libfuse.so.2.9.9 /usr/lib/libfuse.so         &&
ln -sfv ../../lib/libulockmgr.so.1.0.1 /usr/lib/libulockmgr.so &&
install -vm644  Dest/lib/pkgconfig/fuse.pc /usr/lib/pkgconfig  && 
                                                         
install -vm4755 Dest/bin/fusermount       /bin                 &&
install -vm755  Dest/bin/ulockmgr_server  /bin                 &&
install -vm755  Dest/sbin/mount.fuse      /sbin                &&
install -vdm755 /usr/include/fuse                              &&
install -vm644  Dest/usr/include/*.h      /usr/include         &&
install -vm644  Dest/usr/include/fuse/*.h /usr/include/fuse/   &&
install -vm644  Dest/usr/share/man/man1/* /usr/share/man/man1  &&
/sbin/ldconfig -v

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

