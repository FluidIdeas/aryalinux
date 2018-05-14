#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The cURL package contains anbr3ak utility and a library used for transferring files with URL syntaxbr3ak to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP,br3ak SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to bothbr3ak download and upload files can be incorporated into other programsbr3ak to support functions like streaming media.br3ak"
SECTION="basicnet"
VERSION=7.59.0
NAME="curl"

#REC:make-ca
#OPT:c-ares
#OPT:gnutls
#OPT:libidn2
#OPT:mitkrb
#OPT:nghttp2
#OPT:openldap
#OPT:samba
#OPT:stunnel
#OPT:valgrind


cd $SOURCE_DIR

URL=https://curl.haxx.se/download/curl-7.59.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://curl.haxx.se/download/curl-7.59.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/curl/curl-7.59.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/curl/curl-7.59.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.59.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.59.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.59.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.59.0.tar.xz

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

./configure --prefix=/usr                           \
            --disable-static                        \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
rm -rf docs/examples/.deps &&
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
install -v -d -m755 /usr/share/doc/curl-7.59.0 &&
cp -v -R docs/*     /usr/share/doc/curl-7.59.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
