#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="blender"
VERSION="2.79"
DESCRIPTION="Blender is the free and open source 3D creation suite. It supports the entirety of the 3D pipeline—modeling, rigging, animation, simulation, rendering, compositing and motion tracking, even video editing and game creation."

URL=https://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

sudo tar xf $TARBALL -C /opt

sudo tee /etc/profile.d/blender.sh <<EOF
export PATH=$PATH:/opt/blender
EOF

sudo ln -svf /opt/$DIRECTORY /opt/blender
sudo ln -svf /opt/blender/blender.desktop /usr/share/applications/
sudo sed -i "s@Exec=blender@Exec=/opt/blender/blender@g" /opt/blender/blender.desktop

sudo update-desktop-database

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
