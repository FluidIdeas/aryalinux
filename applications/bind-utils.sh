#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:liburcu
#REQ:json-c

cd $SOURCE_DIR
NAME=bind-utils
VERSION=9.20.19
URL=https://ftp.isc.org/isc/bind9/9.20.19/bind-9.20.19.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.isc.org/isc/bind9/9.20.19/bind-9.20.19.tar.xz


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc
make -C lib/isc
make -C lib/dns
make -C lib/ns
make -C lib/isccfg
make -C lib/isccc
make -C bin/dig
make -C bin/nsupdate
make -C bin/rndc
make -C doc
make -C lib/isc      install
make -C lib/dns      install
make -C lib/ns       install
make -C lib/isccfg   install
make -C lib/isccc    install
make -C bin/dig      install
make -C bin/nsupdate install
make -C bin/rndc     install
cp -v doc/man/{dig.1,host.1,nslookup.1,nsupdate.1} /usr/share/man/man1
cp -v doc/man/rndc.8 /usr/share/man/man8

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd