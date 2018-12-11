#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The at package provide delayed jobbr3ak execution and batch processing. It is required for Linux Standardsbr3ak Base (LSB) conformance.br3ak"
SECTION="general"
VERSION=3.1.23
NAME="at"

#OPT:linux-pam


cd $SOURCE_DIR

URL=http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at/at_3.1.23.orig.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/at/at_3.1.23.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/at_3.1.23.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/at_3.1.23.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at/at_3.1.23.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at/at_3.1.23.orig.tar.gz

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
groupadd -g 17 atd                                                  &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i '/docdir/s/=.*/= @docdir@/' Makefile.in


autoreconf


./configure --with-daemon_username=atd        \
            --with-daemon_groupname=atd       \
            SENDMAIL=/usr/sbin/sendmail       \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install \
        docdir=/usr/share/doc/at-3.1.23 \
      atdocdir=/usr/share/doc/at-3.1.23

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable atd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
