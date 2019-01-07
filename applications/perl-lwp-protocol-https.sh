#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-io-socket-ssl
#REQ:perl-libwww-perl
#REQ:make-ca

cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/LWP-Protocol-https-6.07-system_certs-1.patch

NAME=lwp::protocol::https-6.07
VERSION=1.patch
URL=http://www.linuxfromscratch.org/patches/blfs/svn/LWP-Protocol-https-6.07-system_certs-1.patch

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

patch -Np1 -i ../LWP-Protocol-https-6.07-system_certs-1.patch
perl Makefile.PL &&
make &&
make test

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
