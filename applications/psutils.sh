#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak PSUtils is a set of utilities tobr3ak manipulate PostScript files.br3ak"
SECTION="pst"
VERSION=17
NAME="psutils"



cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz

if [ ! -z $URL ]
then
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz

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

sed 's@/usr/local@/usr@g' Makefile.unix > Makefile &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


lp -o number-up=2 <em class="replaceable"><code><filename></em>




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
