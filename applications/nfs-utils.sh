#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The NFS Utilities package containsbr3ak the userspace server and client tools necessary to use the kernel'sbr3ak NFS abilities. NFS is a protocol that allows sharing file systemsbr3ak over the network.br3ak"
SECTION="basicnet"
VERSION=2.3.3
NAME="nfs-utils"

#REQ:libtirpc
#REQ:rpcsvc-proto
#REQ:rpcbind
#OPT:lvm2
#OPT:libnfsidmap
#OPT:libnsl
#OPT:sqlite
#OPT:mitkrb
#OPT:libcap


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/nfs/nfs-utils-2.3.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/nfs/nfs-utils-2.3.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-2.3.3.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if ! grep nogroup /etc/group &>/dev/null; then groupadd -g 99 nogroup; fi
if ! grep nobody /etc/passwd &>/dev/null; then useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup -s /bin/false -u 99 nobody; fi
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --sbindir=/sbin        \
            --disable-nfsv4        \
            --disable-gss &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                      &&
mv -v /sbin/start-statd /usr/sbin &&
chmod u+w,go+r /sbin/mount.nfs    &&
chown nobody.nogroup /var/lib/nfs

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
make install-nfs-client

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
