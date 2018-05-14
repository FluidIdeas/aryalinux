#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The noto-fonts package ('No Tofu'br3ak i.e. avoiding boxes with dots [ hex digits ] when a glyph cannot bebr3ak found) is a set of fonts which aim to cover <span class=\"emphasis\"><em>every glyph in unicode, no matter howbr3ak obscure</em>. These fonts, or at least the Sans Serif fonts,br3ak are used by KF5 (initially only for gtk applications).br3ak"
SECTION="kde"
VERSION=29
NAME="noto-fonts"

#REQ:unzip

cd $SOURCE_DIR

wget -nc https://github.com/googlei18n/noto-fonts/archive/v2015-09-29-license-adobe.tar.gz
wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip

sudo install -d -m755         /usr/share/fonts/noto   &&
sudo unzip Noto-hinted.zip -d /usr/share/fonts/noto   &&
sudo chmod 0644               /usr/share/fonts/noto/* &&
sudo fc-cache


tar xf v2015-09-29-license-adobe.tar.gz
cd noto-fonts-2015-09-29-license-adobe

sudo install -d -m755         /usr/share/fonts/noto                                 &&
sudo cp -v LICENSE hinted/*.ttf unhinted/NotoSansSymbols*.ttf /usr/share/fonts/noto &&
sudo rm -v /usr/share/fonts/noto/Noto*UI*                                           &&
sudo chmod 0644               /usr/share/fonts/noto/*                               &&
sudo fc-cache

cd $SOURCE_DIR
sudo rm -r noto-fonts-2015-09-29-license-adobe

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
