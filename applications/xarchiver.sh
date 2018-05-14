#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak XArchiver is a GTK+ archive manager with support for tar, xz,br3ak bzip2, gzip, zip, 7z, rar, lzo and many other archive formats.br3ak"
SECTION="xsoft"
VERSION=0.5.4
NAME="xarchiver"

#REQ:gtk2
#REQ:gtk3
#OPT:cpio
#OPT:lzo
#OPT:p7zip
#OPT:unrar
#OPT:unzip
#OPT:zip


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xarchiver/xarchiver-0.5.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xarchiver-0.5.4-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xarchiver/xarchiver-0.5.4-fixes-1.patch

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

patch -Np1 -i ../xarchiver-0.5.4-fixes-1.patch &&
./autogen.sh --prefix=/usr               \
             --libexecdir=/usr/lib/xfce4 \
             --disable-gtk3              \
             --docdir=/usr/share/doc/xarchiver-0.5.4 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCDIR=/usr/share/doc/xarchiver-0.5.4 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
