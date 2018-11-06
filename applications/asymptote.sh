#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Asymptote is a powerfulbr3ak descriptive vector graphics language that provides a naturalbr3ak coordinate-based framework for technical drawing. Labels andbr3ak equations can be typeset with LaTeX.br3ak"
SECTION="pst"
VERSION=2.47
NAME="asymptote"

#REQ:gs
#REQ:texlive
#REC:freeglut
#REC:gc
#REC:libtirpc
#OPT:fftw
#OPT:gsl
#OPT:libsigsegv
#OPT:qt5


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/asymptote/asymptote-2.47.src.tgz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/asymptote/asymptote-2.47.src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.47.src.tgz

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

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
./configure --prefix=/opt/texlive/2018                          \
            --bindir=/opt/texlive/2018/bin/$TEXARCH             \
            --datarootdir=/opt/texlive/2018/texmf-dist          \
            --infodir=/opt/texlive/2018/texmf-dist/doc/info     \
            --libdir=/opt/texlive/2018/texmf-dist               \
            --mandir=/opt/texlive/2018/texmf-dist/doc/man       \
            --enable-gc=system                                  \
            --with-latex=/opt/texlive/2018/texmf-dist/tex/latex \
            --with-context=/opt/texlive/2018/texmf-dist/tex/context/third &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
