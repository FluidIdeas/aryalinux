#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Git is a free and open source,br3ak distributed version control system designed to handle everythingbr3ak from small to very large projects with speed and efficiency. Everybr3ak Git clone is a full-fledgedbr3ak repository with complete history and full revision trackingbr3ak capabilities, not dependent on network access or a central server.br3ak Branching and merging are fast and easy to do. Git is used for version control of files, muchbr3ak like tools such as <a class=\"xref\" href=\"mercurial.html\" title=\"Mercurial-4.7.2\">Mercurial-4.7.2</a>, Bazaar, <a class=\"xref\" href=\"subversion.html\" br3ak title=\"Subversion-1.10.3\">Subversion-1.10.3</a>, <a class=\"ulink\" br3ak href=\"http://www.nongnu.org/cvs/\">CVS</a>, Perforce, and Teambr3ak Foundation Server.br3ak"
SECTION="general"
VERSION=2.19.1
NAME="git"

#REC:curl
#REC:perl-modules#perl-error
#REC:python2
#OPT:pcre2
#OPT:pcre
#OPT:subversion
#OPT:tk
#OPT:valgrind
#OPT:xmlto
#OPT:asciidoc


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/software/scm/git/git-2.19.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/software/scm/git/git-2.19.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-2.19.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/git/git-2.19.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.19.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.19.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.19.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.19.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.19.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.19.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.19.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.19.1.tar.xz

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

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../git-manpages-2.19.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp   /usr/share/doc/git-2.19.1 &&
tar   -xf   ../git-htmldocs-2.19.1.tar.xz \
      -C    /usr/share/doc/git-2.19.1 --no-same-owner --no-overwrite-dir &&
find        /usr/share/doc/git-2.19.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.19.1 -type f -exec chmod 644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
