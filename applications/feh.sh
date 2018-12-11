#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak feh is a fast, lightweight imagebr3ak viewer which uses Imlib2. It is commandline-driven and supportsbr3ak multiple images through slideshows, thumbnail browsing or multiplebr3ak windows, and montages or index prints (using TrueType fonts tobr3ak display file info). Advanced features include fast dynamic zooming,br3ak progressive loading, loading via HTTP (with reload support forbr3ak watching webcams), recursive file opening (slideshow of a directorybr3ak hierarchy), and mouse wheel/keyboard control.br3ak"
SECTION="xsoft"
VERSION=2.28
NAME="feh"

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REC:curl
#OPT:libexif
#OPT:libjpeg
#OPT:imagemagick
#OPT:perl-modules#perl-test-command


cd $SOURCE_DIR

URL=http://feh.finalrewind.org/feh-2.28.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://feh.finalrewind.org/feh-2.28.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/feh/feh-2.28.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/feh/feh-2.28.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.28.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.28.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.28.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.28.tar.bz2

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

sed -i "s:doc/feh:&-2.28:" config.mk &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
