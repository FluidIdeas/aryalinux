#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="These fonts are an extension of, and replacement for, the Bitstream Vera fonts and provide Latin-based scripts with accents and punctuation such as smart-quotes and variant spacing characters, as well as Cyrillic, Greek, Arabic, Hebrew, Armenian, Georgian and some other glyphs. In the absence of the Bitstream Vera fonts (which had much less coverage), these are the default fallback fonts."
SECTION="x"
VERSION=327
NAME="dejavu-fonts"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`

if [ ! -d /usr/share/fonts ]; then
	mkdir -pv /usr/share/fonts
fi

sudo tar -xf $TARBALL -C /usr/share/fonts/

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
