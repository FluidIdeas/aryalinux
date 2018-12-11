#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Exim package contains a Mailbr3ak Transport Agent written by the University of Cambridge, releasedbr3ak under the GNU Public License.br3ak"
SECTION="server"
VERSION=4.91
NAME="exim"

#REQ:libnsl
#REQ:pcre
#OPT:cyrus-sasl
#OPT:libidn
#OPT:linux-pam
#OPT:mariadb
#OPT:openldap
#OPT:gnutls
#OPT:postgresql
#OPT:sqlite
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.91.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/eximftp/exim/exim4/exim-4.91.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exim/exim-4.91.tar.xz || wget -nc ftp://ftp.exim.org/pub/exim/exim4/exim-4.91.tar.xz

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
groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -e 's,^BIN_DIR.*$,BIN_DIRECTORY=/usr/sbin,'    \
    -e 's,^CONF.*$,CONFIGURE_FILE=/etc/exim.conf,' \
    -e 's,^EXIM_USER.*$,EXIM_USER=exim,'           \
    -e '/SUPPORT_TLS/s,^#,,'                       \
    -e '/USE_OPENSSL/s,^#,,'                       \
    -e 's,^EXIM_MONITOR,#EXIM_MONITOR,' src/EDITME > Local/Makefile &&
printf "USE_GDBM = yes\nDBMLIB = -lgdbm\n" >> Local/Makefile &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                    &&
install -v -m644 doc/exim.8 /usr/share/man/man8 &&
install -v -d -m755    /usr/share/doc/exim-4.91 &&
install -v -m644 doc/* /usr/share/doc/exim-4.91 &&
ln -sfv exim /usr/sbin/sendmail                 &&
install -v -d -m750 -o exim -g exim /var/spool/exim

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chmod -v a+wt /var/mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF
exim -v -bi &&
/usr/sbin/exim -bd -q15m

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
make install-exim

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
