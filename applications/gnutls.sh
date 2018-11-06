#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GnuTLS package containsbr3ak libraries and userspace tools which provide a secure layer over abr3ak reliable transport layer. Currently the GnuTLS library implements the proposedbr3ak standards by the IETF's TLS working group. Quoting from the TLSbr3ak protocol specification:br3ak"
SECTION="postlfs"
VERSION=3.5.19
NAME="gnutls"

#REQ:nettle
#REC:make-ca
#REC:libunistring
#REC:libtasn1
#REC:p11-kit
#OPT:doxygen
#OPT:gtk-doc
#OPT:guile
#OPT:libidn
#OPT:libidn2
#OPT:net-tools
#OPT:texlive
#OPT:tl-installer
#OPT:unbound
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.19.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.19.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.19.tar.xz

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

./configure --prefix=/usr \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C doc/reference install-data-local

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
