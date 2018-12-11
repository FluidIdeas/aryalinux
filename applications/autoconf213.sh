#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Autoconf2.13 is an old version ofbr3ak Autoconf . This old versionbr3ak accepts switches which are not valid in more recent versions. Nowbr3ak that firefox has started to usebr3ak python2 for configuring, this oldbr3ak version is required even if configure files have not been changed.br3ak"
SECTION="general"
VERSION=2.13
NAME="autoconf213"

#OPT:dejagnu


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/autoconf/autoconf-2.13.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/autoconf-2.13-consolidated_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/autoconf/autoconf-2.13-consolidated_fixes-1.patch

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

patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch &&
mv -v autoconf.texi autoconf213.texi                      &&
rm -v autoconf.info                                       &&
./configure --prefix=/usr --program-suffix=2.13           &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                      &&
install -v -m644 autoconf213.info /usr/share/info &&
install-info --info-dir=/usr/share/info autoconf213.info

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
