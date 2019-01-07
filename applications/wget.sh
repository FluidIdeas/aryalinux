#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:make-ca
#OPT:gnutls
#OPT:gpgme
#OPT:perl-http-daemon
#OPT:perl-io-socket-ssl
#OPT:libidn2
#OPT:libpsl
#OPT:pcre
#OPT:pcre2
#OPT:python2
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz

NAME=wget
VERSION=1.20.1
URL=https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--sysconfdir=/etc \
--with-ssl=openssl &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
