#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xserver-meta
#REQ:itstool
#REQ:libgcrypt
#REQ:libxklavier
#REQ:systemd
#REQ:polkit


cd $SOURCE_DIR

wget -nc https://github.com/CanonicalLtd/lightdm/releases/download/1.30.0/lightdm-1.30.0.tar.xz


NAME=lightdm
VERSION=1.30.0
URL=https://github.com/CanonicalLtd/lightdm/releases/download/1.30.0/lightdm-1.30.0.tar.xz

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

