#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The UnRar package contains abr3ak <code class=\"filename\">RAR extraction utility used forbr3ak extracting files from <code class=\"filename\">RAR archives.br3ak <code class=\"filename\">RAR archives are usually created withbr3ak WinRAR, primarily in a Windowsbr3ak environment.br3ak"
SECTION="general"
VERSION=5.6.4
NAME="unrar"



cd $SOURCE_DIR

URL=http://www.rarlab.com/rar/unrarsrc-5.6.4.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.rarlab.com/rar/unrarsrc-5.6.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.6.4.tar.gz

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

make -f makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 unrar /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
