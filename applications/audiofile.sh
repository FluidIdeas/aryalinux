#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:alsa-lib
#REQ:flac


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz


NAME=audiofile
VERSION=0.3.6
URL=https://download.gnome.org/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The AudioFile package contains the audio file libraries and two sound file support programs useful to support basic sound file formats."

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


CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&

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

