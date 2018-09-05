#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:thunar

NAME=thunar-archive-plugin
VERSION=0.4.0
DESCRIPTION="The Thunar Archive Plugin allows you to create and extract archive files using the file context menus in the Thunar file manager."
URL=https://git.xfce.org/thunar-plugins/thunar-archive-plugin/snapshot/thunar-archive-plugin-thunar-archive-plugin-0.4.0.tar.gz

cd $SOURCE_DIR
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
GETTEXT_PACKAGE=thunar-archive-plugin ./configure --prefix=/usr &&
make "-j$(nproc)" || make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

