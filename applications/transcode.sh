#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:ffmpeg
#REQ:alsa-lib
#REQ:lame
#REQ:libdvdread
#REQ:libmpeg2
#REQ:x7lib


cd $SOURCE_DIR

wget -nc https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/transcode-1.1.7.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/transcode-1.1.7-ffmpeg4-1.patch


NAME=transcode
VERSION=1.1.7
URL=https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2

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

echo $USER > /tmp/currentuser


sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
       $(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&

patch -Np1 -i ../transcode-1.1.7-ffmpeg4-1.patch                   &&
./configure --prefix=/usr \
            --enable-alsa \
            --enable-libmpeg2 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

