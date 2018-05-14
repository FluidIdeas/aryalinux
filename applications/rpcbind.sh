#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The rpcbind program is abr3ak replacement for portmap. It isbr3ak required for import or export of Network File System (NFS) sharedbr3ak directories.br3ak"
SECTION="basicnet"
VERSION=0.2.4
NAME="rpcbind"

#REQ:libtirpc


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/rpcbind/rpcbind-0.2.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rpcbind/rpcbind-0.2.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/rpcbind-0.2.4-vulnerability_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/rpcbind/rpcbind-0.2.4-vulnerability_fixes-1.patch

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c


patch -Np1 -i ../rpcbind-0.2.4-vulnerability_fixes-1.patch &&
./configure --prefix=/usr       \
            --bindir=/sbin      \
            --enable-warmstarts \
            --with-rpcuser=rpc  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-rpcbind

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
