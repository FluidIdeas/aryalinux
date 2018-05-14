#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Fetchmail package contains abr3ak mail retrieval program. It retrieves mail from remote mail serversbr3ak and forwards it to the local (client) machine's delivery system, sobr3ak it can then be read by normal mail user agents.br3ak"
SECTION="basicnet"
VERSION=6.3.26
NAME="fetchmail"

#REC:procmail
#OPT:python2
#OPT:tk


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fetchmail/fetchmail-6.3.26.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/fetchmail-6.3.26-disable_sslv3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/fetchmail/fetchmail-6.3.26-disable_sslv3-1.patch

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

patch -Np1 -i ../fetchmail-6.3.26-disable_sslv3-1.patch &&
./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.fetchmailrc << "EOF"
set logfile /var/log/fetchmail.log
set no bouncemail
set postmaster root
poll SERVERNAME :
 user <em class="replaceable"><code><username></em> pass <em class="replaceable"><code><password></em>;
 mda "/usr/bin/procmail -f %F -d %T";
EOF
chmod -v 0600 ~/.fetchmailrc




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
