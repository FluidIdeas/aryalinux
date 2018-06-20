#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Mercurial is a distributed sourcebr3ak control management tool similar to Git and Bazaar. Mercurial is written in Python and is used by projects such as Mozillabr3ak and Vim.br3ak"
SECTION="general"
VERSION=4.6
NAME="mercurial"

#REQ:python2
#OPT:python-modules#docutils
#OPT:git
#OPT:gnupg
#OPT:openssh
#OPT:subversion


cd $SOURCE_DIR

URL=https://www.mercurial-scm.org/release/mercurial-4.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.mercurial-scm.org/release/mercurial-4.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-4.6.tar.gz

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

make build


make doc


rm -rf tests/tmp &&
TESTFLAGS="-j<em class="replaceable"><code><N></em> --tmpdir tmp --blacklist blacklists/failed-tests" make check


pushd tests  &&
  rm -rf tmp &&
  ./run-tests.py --tmpdir tmp test-gpg.t
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.hgrc << "EOF"
[ui]
username = <em class="replaceable"><code><user_name> <user@mail></em>
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /etc/mercurial &&
cat > /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
