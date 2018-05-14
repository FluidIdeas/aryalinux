#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libdiscid package contains abr3ak library for creating MusicBrainz DiscIDs from audio CDs. It reads abr3ak CD's table of contents (TOC) and generates an identifier which canbr3ak be used to lookup the CD at MusicBrainz (<a class=\"ulink\" href=\"http://musicbrainz.org\">http://musicbrainz.org</a>). Additionally,br3ak it provides a submission URL for adding the DiscID to the database.br3ak"
SECTION="multimedia"
VERSION=0.6.2
NAME="libdiscid"

#OPT:doxygen


cd $SOURCE_DIR

URL=http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.2.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz

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
