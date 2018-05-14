#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The rsync package contains thebr3ak <span class=\"command\"><strong>rsync</strong> utility. Thisbr3ak is useful for synchronizing large file archives over a network.br3ak"
SECTION="basicnet"
VERSION=3.1.3
NAME="rsync"

#REC:popt


cd $SOURCE_DIR

URL=https://www.samba.org/ftp/rsync/src/rsync-3.1.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.samba.org/ftp/rsync/src/rsync-3.1.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rsync/rsync-3.1.3.tar.gz

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
groupadd -g 48 rsyncd &&
useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
    -s /bin/false -u 48 rsyncd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr --without-included-zlib &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/rsyncd.conf << "EOF"
# This is a basic rsync configuration file
# It exports a single module without user authentication.
motd file = /home/rsync/welcome.msg
use chroot = yes
[localhost]
 path = /home/rsync
 comment = Default rsync module
 read only = yes
 list = yes
 uid = rsyncd
 gid = rsyncd

EOF

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
make install-rsyncd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl stop rsyncd &&
systemctl disable rsyncd &&
systemctl enable rsyncd.socket &&
systemctl start rsyncd.socket

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
