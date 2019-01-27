#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR


NAME=noto-fonts
VERSION=1.4
URL=""

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

sudo mkdir -pv /usr/share/fonts/truetype/noto-fonts
mkdir -pv noto-fonts && cd noto-fonts
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{Sans,Serif,SansDisplay,SerifDisplay,Mono}-hinted.zip
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto{ColorEmoji,Emoji}-unhinted.zip
find . -name *zip -exec unzip -d /usr/share/fonts/truetype/noto-fonts {} \;

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
