#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Dovecot is an Internet Messagebr3ak Access Protocol (IMAP) and Post Office Protocol (POP) server,br3ak written primarily with security in mind. Dovecot aims to be lightweight, fast and easybr3ak to set up as well as highly configurable and easily extensible withbr3ak plugins.br3ak"
SECTION="server"
VERSION=2.3.1
NAME="dovecot"

#REQ:libtirpc
#OPT:clucene
#OPT:icu
#OPT:libcap
#OPT:linux-pam
#OPT:lua
#OPT:mariadb
#OPT:mitkrb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.dovecot.org/releases/2.3/dovecot-2.3.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.dovecot.org/releases/2.3/dovecot-2.3.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dovecot/dovecot-2.3.1.tar.gz

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
groupadd -g 42 dovecot &&
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot &&
groupadd -g 43 dovenull &&
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


CFLAGS+="-I/usr/include/tirpc" \
LDFLAGS+="-ltirpc" \
./configure --prefix=/usr                          \
            --sysconfdir=/etc                      \
            --localstatedir=/var                   \
            --docdir=/usr/share/doc/dovecot-2.3.1 \
            --disable-static                       \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -rv /usr/share/doc/dovecot-2.3.1/example-config/* /etc/dovecot

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/^\!include / s/^/#/' /etc/dovecot/dovecot.conf &&
chmod -v 1777 /var/mail &&
cat > /etc/dovecot/local.conf << "EOF"
protocols = imap
ssl = no
# The next line is only needed if you have no IPv6 network interfaces
listen = *
mail_location = mbox:~/Mail:INBOX=/var/mail/%u
userdb {
 driver = passwd
}
passdb {
 driver = shadow
}
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable dovecot

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
