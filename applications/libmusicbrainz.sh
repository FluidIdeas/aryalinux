#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libmusicbrainz packagebr3ak contains a library which allows you to access the data held on thebr3ak MusicBrainz server. This is useful for adding MusicBrainz lookupbr3ak capabilities to other applications.br3ak"
SECTION="multimedia"
VERSION=2.1.5
NAME="libmusicbrainz"

#OPT:python2


cd $SOURCE_DIR

URL=http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libmusicbrainz-2.1.5-missing-includes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libmusicbrainz/libmusicbrainz-2.1.5-missing-includes-1.patch

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

patch -Np1 -i ../libmusicbrainz-2.1.5-missing-includes-1.patch &&
CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make


(cd python && python setup.py build)



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D docs/mb_howto.txt \
    /usr/share/doc/libmusicbrainz-2.1.5/mb_howto.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
(cd python && python setup.py install)

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
