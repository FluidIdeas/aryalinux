#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Enscript converts ASCII text filesbr3ak to PostScript, HTML, RTF, ANSI and overstrikes.br3ak"
SECTION="pst"
VERSION=1.6.6
NAME="enscript"

#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/enscript/enscript-1.6.6.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz

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

./configure --prefix=/usr              \
            --sysconfdir=/etc/enscript \
            --localstatedir=/var       \
            --with-media=Letter &&
make &&
pushd docs &&
  makeinfo --plaintext -o enscript.txt enscript.texi &&
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/enscript-1.6.6 &&
install -v -m644    README* *.txt docs/*.txt \
                    /usr/share/doc/enscript-1.6.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 docs/*.{dvi,pdf,ps} \
                 /usr/share/doc/enscript-1.6.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
