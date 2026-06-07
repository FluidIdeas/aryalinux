#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:python-dependencies#charset-normalizer
#REQ:python-dependencies#idna
#REQ:python-dependencies#urllib3
#REQ:make-ca
#REQ:p11-kit

cd $SOURCE_DIR
NAME=python-modules#requests
VERSION=2.32.5
URL=https://files.pythonhosted.org/packages/source/r/requests/requests-2.32.5.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://files.pythonhosted.org/packages/source/r/requests/requests-2.32.5.tar.gz
wget -nc https://www.linuxfromscratch.org/patches/blfs/svn/requests-2.28.2-use_system_certs-1.patch


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
patch -Np1 -i ../requests-2.28.2-use_system_certs-1.patch

echo $USER > /tmp/currentuser

patch -Np1 -i ../requests-use_system_certs-1.patch
pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install pytest-mock    \
             pytest-httpbin \
             pytest-cov     \
             pytest-xdist   \
             pysocks        \
             trustme
python3 /usr/bin/pytest tests
deactivate


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user requests
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd