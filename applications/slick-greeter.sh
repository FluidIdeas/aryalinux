#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Slick greeter is a slick-looking LightDM greeter"
SECTION="xsoft"
VERSION=1.2.2
NAME="slick-greeter"

#REQ:lightdm

cd $SOURCE_DIR

URL=https://github.com/linuxmint/slick-greeter/archive/1.2.2.tar.gz

whoami > /tmp/currentuser

wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

tar xf $TARBALL
cd $DIRECTORY
./autogen.sh --prefix=/usr &&
make "-j`nproc`" || make
sudo make install

# Replacing the current greeter

greeter_line=$(grep "^greeter-session" /etc/lightdm/lightdm.conf)
sudo sed -i "s@$greeter_line@greeter-session=slick-greeter@g" /etc/lightdm/lightdm.conf

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
