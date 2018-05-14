#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenSSH package containsbr3ak <span class=\"command\"><strong>ssh</strong> clients and thebr3ak <span class=\"command\"><strong>sshd</strong> daemon. This isbr3ak useful for encrypting authentication and subsequent traffic over abr3ak network. The <span class=\"command\"><strong>ssh</strong> andbr3ak <span class=\"command\"><strong>scp</strong> commands arebr3ak secure implementations of <span class=\"command\"><strong>telnet</strong> and <span class=\"command\"><strong>rcp</strong> respectively.br3ak"
SECTION="postlfs"
VERSION=7.7p1
NAME="openssh"

#OPT:linux-pam
#OPT:mitkrb
#OPT:openjdk
#OPT:net-tools
#OPT:sysstat
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.7p1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openssh-7.7p1-openssl-1.1.0-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openssh/openssh-7.7p1-openssl-1.1.0-1.patch

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
install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&
groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../openssh-7.7p1-openssl-1.1.0-1.patch &&
./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-7.7p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-7.7p1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
chmod 644 /etc/pam.d/sshd &&
echo "UsePAM yes" >> /etc/ssh/sshd_config

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
make install-sshd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
