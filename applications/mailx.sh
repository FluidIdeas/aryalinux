#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Heirloom mailx packagebr3ak (formerly known as the Nailbr3ak package) contains <span class=\"command\"><strong>mailx</strong>, a command-line Mail Userbr3ak Agent derived from Berkeley Mail. It is intended to provide thebr3ak functionality of the POSIX <span class=\"command\"><strong>mailx</strong> command with additionalbr3ak support for MIME messages, IMAP (including caching), POP3, SMTP,br3ak S/MIME, message threading/sorting, scoring, and filtering.br3ak Heirloom mailx is especiallybr3ak useful for writing scripts and batch processing.br3ak"
SECTION="basicnet"
VERSION=12.5
NAME="mailx"

#OPT:openssl10
#OPT:nss
#OPT:mitkrb


cd $SOURCE_DIR

URL=http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-mailx_12.5.orig.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/heirloom-mailx-12.5-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/heirloom-mailx/heirloom-mailx-12.5-fixes-1.patch

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

patch -Np1 -i ../heirloom-mailx-12.5-fixes-1.patch &&
sed 's@<openssl@<openssl-1.0/openssl@' \
    -i openssl.c fio.c makeconfig      &&
make -j1 LDFLAGS+="-L /usr/lib/openssl-1.0/" \
     SENDMAIL=/usr/sbin/sendmail



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr UCBINSTALL=/usr/bin/install install &&
ln -v -sf mailx /usr/bin/mail &&
ln -v -sf mailx /usr/bin/nail &&
install -v -m755 -d     /usr/share/doc/heirloom-mailx-12.5 &&
install -v -m644 README /usr/share/doc/heirloom-mailx-12.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
