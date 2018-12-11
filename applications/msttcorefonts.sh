#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="msttcorefonts"
DESCRIPTION="Microsoft core fonts"
VERSION=""
cd $SOURCE_DIR

FONTS="wd97vwr32.exe webdin32.exe verdan32.exe trebuc32.exe times32.exe impact32.exe georgi32.exe courie32.exe comic32.exe arialb32.exe arial32.exe andale32.exe"

mkdir msttcorefonts
cd msttcorefonts

for font in $FONTS
do
	wget -nc "http://liquidtelecom.dl.sourceforge.net/project/corefonts/the fonts/final/$font"
	7z e -y $font
done

sudo mkdir -pv /usr/share/fonts/msttcorefonts

sudo cp -vf *TTF /usr/share/fonts/msttcorefonts/
sudo cp -vf *ttf /usr/share/fonts/msttcorefonts/

cd $SOURCE_DIR
rm -rf msttcorefonts

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
