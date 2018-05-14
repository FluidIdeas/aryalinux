#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xindy is an index processor thatbr3ak can be used to generate book-like indexes for arbitrarybr3ak document-preparation systems. This includes systems such as TeX andbr3ak LaTeX, the roff-family, SGML/XML-based systems (e.g., HTML) thatbr3ak process some kind of text and generate indexing information.br3ak"
SECTION="pst"
VERSION=2.5.1
NAME="xindy"

#REQ:clisp
#REQ:texlive


cd $SOURCE_DIR

URL=http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xindy-2.5.1-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xindy/xindy-2.5.1-upstream_fixes-1.patch

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
sed -i "s/ grep -v '^;'/ awk NF/" make-rules/inputenc/Makefile.in &&
sed -i 's%\(indexentry\)%\1\\%' make-rules/inputenc/make-inp-rules.pl &&
patch -Np1 -i ../xindy-2.5.1-upstream_fixes-1.patch &&
./configure --prefix=/opt/texlive/2017              \
            --bindir=/opt/texlive/2017/bin/$TEXARCH \
            --datarootdir=/opt/texlive/2017         \
            --includedir=/usr/include               \
            --libdir=/opt/texlive/2017/texmf-dist   \
            --mandir=/opt/texlive/2017/texmf-dist/doc/man &&
make LC_ALL=POSIX



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
