#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python2


cd $SOURCE_DIR

wget -nc https://www.mercurial-scm.org/release/mercurial-5.1.tar.gz


NAME=mercurial
VERSION=5.1
URL=https://www.mercurial-scm.org/release/mercurial-5.1.tar.gz
SECTION="Programming"
DESCRIPTION="Mercurial is a distributed source control management tool similar to Git and Bazaar. Mercurial is written in Python and is used by projects such as Mozilla and Vim."

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

echo $USER > /tmp/currentuser


make build
sed -i '/runrst/s/N)/N)3/' doc/Makefile &&
2to3-3.7 -w doc/hgmanpage.py            &&
make doc
rm -rf tests/tmp &&
TESTFLAGS="-j<N> --tmpdir tmp --blacklist blacklists/fsmonitor --blacklist blacklists/linux-vfat" make check
pushd tests  &&
  rm -rf tmp &&
  ./run-tests.py --tmpdir tmp test-gpg.t
popd
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install-bin
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install-doc
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat >> ~/.hgrc << "EOF"
[ui]
username = <user_name> <user@mail>
EOF
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 /etc/mercurial &&
cat > /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/pki/tls/certs/ca-bundle.crt
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

