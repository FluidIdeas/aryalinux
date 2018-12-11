#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Yasm is a complete rewrite of thebr3ak <a class=\"xref\" href=\"nasm.html\" title=\"NASM-2.13.03\">NASM-2.13.03</a> assembler. It supports the x86 andbr3ak AMD64 instruction sets, accepts NASM and GAS assembler syntaxes andbr3ak outputs binary, ELF32 and ELF64 object formats.br3ak"
SECTION="general"
VERSION=1.3.0
NAME="yasm"

#OPT:python2


cd $SOURCE_DIR

URL=http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz

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

sed -i 's#) ytasm.*#)#' Makefile.in &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
