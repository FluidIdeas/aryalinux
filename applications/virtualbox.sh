#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xserver-meta


cd $SOURCE_DIR



NAME=virtualbox
VERSION=nightly


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

sudo pip install bs4

wget https://www.virtualbox.org/wiki/Linux_Downloads -O Linux_Downloads

cat > /tmp/parser.py<<"EOF"
from bs4 import BeautifulSoup

with open('Linux_Downloads') as fp:
	doc = BeautifulSoup(fp.read(), features="html.parser")

for anchor in doc.select('a[href]'):
	if 'All distributions' in str(anchor):
		print(anchor['href'])
EOF

url=$(python /tmp/parser.py)
tarball=$(echo $url | rev | cut -d/ -f1 | rev)

KERNEL_VERSION=$(uname -r)
KERNEL_MAJOR_VERSION=$(uname -r | cut -d '.' -f1)
KERNEL_URL=https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_VERSION.tar.xz
KERNEL_TARBALL=$(echo $KERNEL_URL | rev | cut -d/ -f1 | rev)
VBOX_INSTALLER=$(echo $url | rev | cut -d/ -f1 | rev)
VERSION=$(echo $VBOX_INSTALLER | cut -d "-" -f2)

wget -nc $url
wget -nc $KERNEL_URL

KERNEL_DIR=$(tar tf $KERNEL_TARBALL | cut -d/ -f1 | uniq)

mkdir -pv /usr/src/
sudo tar xf $KERNEL_TARBALL -C /usr/src
sudo ln -svf /usr/src/$KERNEL_DIR /lib/modules/$KERNEL_VERSION/build

pushd /usr/src/$KERNEL_DIR
sudo make oldconfig
sudo make prepare
sudo make scripts
popd

chmod a+x $VBOX_INSTALLER

sudo ./$VBOX_INSTALLER

sudo ln -svf /opt/VirtualBox/virtualbox.desktop /usr/share/applications/
sudo update-desktop-database
sudo update-mime-database /usr/share/mime


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

