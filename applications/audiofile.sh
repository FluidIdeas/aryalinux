#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The AudioFile package contains thebr3ak audio file libraries and two sound file support programs useful tobr3ak support basic sound file formats.br3ak"
SECTION="multimedia"
VERSION=0.3.6
NAME="audiofile"

#REQ:alsa-lib
#REC:flac
#OPT:asciidoc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
