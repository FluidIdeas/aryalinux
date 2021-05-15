#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:ffmpeg
#REQ:alsa
#REQ:pulseaudio
#REQ:libdvdnav


cd $SOURCE_DIR

NAME=xine-lib
VERSION=1.2.11
URL=https://downloads.sourceforge.net/xine/xine-lib-1.2.11.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The Xine Libraries package contains xine libraries. These are useful for interfacing with external plug-ins that allow the flow of information from the source to the audio and video hardware."


mkdir -pv $NAME
pushd $NAME

wget -nc https://downloads.sourceforge.net/xine/xine-lib-1.2.11.tar.xz
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/xine-lib-1.2.11.tar.xz


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


./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.11 &&
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

popd