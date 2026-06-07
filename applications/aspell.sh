#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:which

cd $SOURCE_DIR
NAME=aspell
VERSION=0.60.8.2
URL=https://ftpmirror.gnu.org/aspell/aspell-0.60.8.2.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftpmirror.gnu.org/aspell/aspell-0.60.8.2.tar.gz


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

./configure --prefix=/usr
make
tar xf ../aspell6-en-2020.12.07-0.tar.bz2
cd aspell6-en-2020.12.07-0
./configure
make
ln -svfn aspell-0.60 /usr/lib/aspell


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m755 -d /usr/share/doc/aspell-0.60.8.2/aspell{,-dev}.html
install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.8.2/aspell.html
install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.8.2/aspell-dev.html
install -v -m 755 scripts/ispell /usr/bin/
install -v -m 755 scripts/spell /usr/bin/
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd