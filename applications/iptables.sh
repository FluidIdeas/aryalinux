#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The next part of this chapter deals with firewalls. The principalbr3ak firewall tool for Linux is Iptables. You will need to installbr3ak Iptables if you intend on usingbr3ak any form of a firewall.br3ak"
SECTION="postlfs"
VERSION=1.6.2
NAME="iptables"



cd $SOURCE_DIR

URL=http://www.netfilter.org/projects/iptables/files/iptables-1.6.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.netfilter.org/projects/iptables/files/iptables-1.6.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/iptables/iptables-1.6.2.tar.bz2 || wget -nc ftp://ftp.netfilter.org/pub/iptables/iptables-1.6.2.tar.bz2

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

./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../../sbin/xtables-multi /usr/bin/iptables-xml &&
for file in ip4tc ip6tc ipq iptc xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done

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
make install-iptables

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
