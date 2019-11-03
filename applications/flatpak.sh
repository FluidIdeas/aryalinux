#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libostree
#REQ:appstream-glib
#REQ:libseccomp


cd $SOURCE_DIR

wget -nc https://github.com/flatpak/flatpak/releases/download/1.5.0/flatpak-1.5.0.tar.xz


NAME=flatpak
VERSION=1.5.0
URL=https://github.com/flatpak/flatpak/releases/download/1.5.0/flatpak-1.5.0.tar.xz

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

./configure --prefix=/usr &&
make -j$(nproc)
sudo make install
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo tee /etc/profile.d/flatpak.sh << "EOF"
export XDG_DATA_DIRS=/usr/var/lib/flatpak/exports/share/:/usr/local/share/:/usr/share/
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

