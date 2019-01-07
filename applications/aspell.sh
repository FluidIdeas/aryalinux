#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:which

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz

NAME=aspell
VERSION=0.60.6.1
URL=https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz

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

sed -i '/ top.do_check ==/s/top.do_check/*&/' modules/filter/tex.cpp &&
sed -i '/word ==/s/word/*&/' prog/check_funs.cpp
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -svfn aspell-0.60 /usr/lib/aspell &&

install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
/usr/share/doc/aspell-0.60.6.1/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
/usr/share/doc/aspell-0.60.6.1/aspell-dev.html
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

./configure &&
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
