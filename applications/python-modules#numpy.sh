#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:python-modules#cython
#REQ:python-dependencies#pyproject-metadata

cd $SOURCE_DIR
NAME=python-modules#numpy
VERSION=2.4.2
URL=https://files.pythonhosted.org/packages/source/n/numpy/numpy-2.4.2.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://files.pythonhosted.org/packages/source/n/numpy/numpy-2.4.2.tar.gz


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

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir \
           -C setup-args=-Dallow-noblas=true $PWD
mkdir -p test
cd       test
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install hypothesis
python3 -c "import numpy, sys; sys.exit(numpy.test() is False)"
deactivate


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user numpy
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd