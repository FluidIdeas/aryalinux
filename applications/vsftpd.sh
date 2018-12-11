#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The vsftpd package contains a verybr3ak secure and very small FTP daemon. This is useful for serving filesbr3ak over a network.br3ak"
SECTION="server"
VERSION=3.0.3
NAME="vsftpd"

#REQ:libnsl
#OPT:libcap
#OPT:linux-pam


cd $SOURCE_DIR

URL=https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz

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
install -v -d -m 0755 /usr/share/vsftpd/empty &&
install -v -d -m 0755 /home/ftp               &&
groupadd -g 47 vsftpd                         &&
groupadd -g 45 ftp                            &&
useradd -c "vsftpd User"  -d /dev/null -g vsftpd -s /bin/false -u 47 vsftpd &&
useradd -c anonymous_user -d /home/ftp -g ftp    -s /bin/false -u 45 ftp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 vsftpd        /usr/sbin/vsftpd    &&
install -v -m 644 vsftpd.8      /usr/share/man/man8 &&
install -v -m 644 vsftpd.conf.5 /usr/share/man/man5 &&
install -v -m 644 vsftpd.conf   /etc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/vsftpd.conf << "EOF"
background=YES
listen=YES
nopriv_user=vsftpd
secure_chroot_dir=/usr/share/vsftpd/empty
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/vsftpd.conf << "EOF"
local_enable=YES
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/vsftpd << "EOF" &&
# Begin /etc/pam.d/vsftpd
auth required /lib/security/pam_listfile.so item=user sense=deny \
 file=/etc/ftpusers \
 onerr=succeed
auth required pam_shells.so
auth include system-auth
account include system-account
session include system-session
EOF
cat >> /etc/vsftpd.conf << "EOF"
session_support=YES
pam_service_name=vsftpd
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
make install-vsftpd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
