#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="A UI for managing virtual machines for Qemu, VirtualBox, VMWare etc."
NAME="virt-manager"
VERSION="1.4.0"

#REQ:python2
#REQ:gtk3
#REQ:libvirt
#REQ:libvirt-python
#REQ:libvirt-glib
#REQ:python-ipaddr
#REQ:python-requests
#REQ:python-modules#pygobject3
#REQ:libosinfo

cd $SOURCE_DIR

URL="https://virt-manager.org/download/sources/virt-manager/virt-manager-1.4.0.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

sudo systemctl enable libvirtd
sudo systemctl enable libvirt-guests

sudo systemctl start libvirtd
sudo systemctl start libvirt-guests

sudo sed -i "s@Exec=virt-manager@Exec=sudo virt-manager@g" /usr/share/applications/virt-manager.desktop

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
