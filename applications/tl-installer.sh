#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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

cd $SOURCE_DIR

wget -nc http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/readline/readline-6.3-upstream_fixes-3.patch
wget -nc https://cpan.metacpan.org/authors/id/S/SR/SREZIC/Tk-804.034.tar.gz

NAME=tl-installer
VERSION=unx
URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
TEXLIVE_INSTALL_PREFIX=/opt/texlive ./install-tl
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
