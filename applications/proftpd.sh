#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ProFTPD package contains abr3ak secure and highly configurable FTP daemon. This is useful forbr3ak serving large file archives over a network.br3ak"
SECTION="server"
VERSION=1.3.6
NAME="proftpd"

#OPT:libcap
#OPT:linux-pam
#OPT:mariadb
#OPT:pcre
#OPT:postgresql


cd $SOURCE_DIR

URL=ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.6.tar.gz

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
groupadd -g 46 proftpd                             &&
useradd -c proftpd -d /srv/ftp -g proftpd \
        -s /usr/bin/proftpdshell -u 46 proftpd     &&
install -v -d -m775 -o proftpd -g proftpd /srv/ftp &&
ln -v -s /bin/false /usr/bin/proftpdshell          &&
echo /usr/bin/proftpdshell >> /etc/shells

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/run &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                   &&
install -d -m755 /usr/share/doc/proftpd-1.3.6 &&
cp -Rv doc/*     /usr/share/doc/proftpd-1.3.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/proftpd.conf << "EOF"
# This is a basic ProFTPD configuration file
# It establishes a single server and a single anonymous login.
ServerName "ProFTPD Default Installation"
ServerType standalone
DefaultServer on
# Port 21 is the standard FTP port.
Port 21
# Umask 022 is a good standard umask to prevent new dirs and files
# from being group and world writable.
Umask 022
# To prevent DoS attacks, set the maximum number of child processes
# to 30. If you need to allow more than 30 concurrent connections
# at once, simply increase this value. Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
MaxInstances 30
# Set the user and group that the server normally runs at.
User proftpd
Group proftpd
# To cause every FTP user to be "jailed" (chrooted) into their home
# directory, uncomment this line.
#DefaultRoot ~
# Normally, files should be overwritable.
<Directory /*>
 AllowOverwrite on
</Directory>
# A basic anonymous configuration, no upload directories.
<Anonymous ~proftpd>
 User proftpd
 Group proftpd
 # Clients should be able to login with "anonymous" as well as "proftpd"
 UserAlias anonymous proftpd
 # Limit the maximum number of anonymous logins
 MaxClients 10
 # 'welcome.msg' should be displayed at login, and '.message' displayed
 # in each newly chdired directory.
 DisplayLogin welcome.msg
 DisplayChdir .message
 # Limit WRITE everywhere in the anonymous chroot
 <Limit WRITE>
 DenyAll
 </Limit>
</Anonymous>
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
make install-proftpd

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
