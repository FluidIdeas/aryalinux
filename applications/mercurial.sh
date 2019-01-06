#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:python2
#OPT:docutils
#OPT:git
#OPT:gnupg
#OPT:openssh
#OPT:subversion

cd $SOURCE_DIR

wget -nc https://www.mercurial-scm.org/release/mercurial-4.8.1.tar.gz

NAME=mercurial
VERSION=4.8.1
URL=https://www.mercurial-scm.org/release/mercurial-4.8.1.tar.gz

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

make build
make doc
rm -rf tests/tmp &&
TESTFLAGS="-j<em class="replaceable"><code><N></code></em> --tmpdir tmp --blacklist blacklists/failed-tests" make check
pushd tests  &&
  rm -rf tmp &&
  ./run-tests.py --tmpdir tmp test-gpg.t
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make PREFIX=/usr install-bin
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make PREFIX=/usr install-doc
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat >> ~/.hgrc << "EOF"
<code class="literal">[ui] username = <em class="replaceable"><code><user_name> <user@mail></code></em></code>
EOF

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -d -m755 /etc/mercurial &&
cat > /etc/mercurial/hgrc << "EOF"
<code class="literal">[web] cacerts = /etc/pki/tls/certs/ca-bundle.crt</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
