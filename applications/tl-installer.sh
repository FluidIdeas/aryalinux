#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The TeX Live package is abr3ak comprehensive TeX document production system. It includes TeX,br3ak LaTeX2e, ConTeXt, Metafont, MetaPost, BibTeX and many otherbr3ak programs; an extensive collection of macros, fonts andbr3ak documentation; and support for typesetting in many differentbr3ak scripts from around the world.br3ak"
SECTION="pst"
VERSION=null
NAME="tl-installer"

#REC:gnupg
#REC:gs
#REC:x7lib
#REC:libxcb
#REC:epdfview
#REC:glu
#REC:freeglut
#REC:python2
#REC:ruby
#REC:tk
#REC:xorg-server


cd $SOURCE_DIR

URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/readline/readline-6.3-upstream_fixes-3.patch

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
TEXLIVE_INSTALL_PREFIX=/opt/texlive ./install-tl

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
