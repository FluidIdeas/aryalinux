#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak XSane is another front end forbr3ak <a class=\"xref\" href=\"sane.html\" title=\"SANE-1.0.27\">SANE-1.0.27</a>. It has additional features tobr3ak improve the image quality and ease of use compared to <span class=\"command\"><strong>xscanimage</strong>.br3ak"
SECTION="pst"
VERSION=0.999
NAME="xsane"

#REQ:gtk2
#REQ:sane
#OPT:lcms
#OPT:gimp


cd $SOURCE_DIR

URL=http://www.xsane.org/download/xsane-0.999.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.xsane.org/download/xsane-0.999.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz

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

sed -i -e 's/png_ptr->jmpbuf/png_jmpbuf(png_ptr)/' src/xsane-save.c &&
./configure --prefix=/usr                                           &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make xsanedocdir=/usr/share/doc/xsane-0.999 install &&
ln -v -s ../../doc/xsane-0.999 /usr/share/sane/xsane/doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s <browser> /usr/bin/netscape

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s /usr/bin/xsane /usr/lib/gimp/2.0/plug-ins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
