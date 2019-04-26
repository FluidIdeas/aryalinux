#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gs
#REQ:texlive
#REC:freeglut
#REC:gc
#REC:glew
#REC:glm
#REC:libtirpc

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/asymptote/asymptote-2.49.src.tgz

NAME=asymptote
VERSION=2.49.src
URL=https://downloads.sourceforge.net/asymptote/asymptote-2.49.src.tgz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

./configure --prefix=/opt/texlive/2018 \
--bindir=/opt/texlive/2018/bin/$TEXARCH \
--datarootdir=/opt/texlive/2018/texmf-dist \
--infodir=/opt/texlive/2018/texmf-dist/doc/info \
--libdir=/opt/texlive/2018/texmf-dist \
--mandir=/opt/texlive/2018/texmf-dist/doc/man \
--enable-gc=system \
--with-latex=/opt/texlive/2018/texmf-dist/tex/latex \
--with-context=/opt/texlive/2018/texmf-dist/tex/context/third &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
