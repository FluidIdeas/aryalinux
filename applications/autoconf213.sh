#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:dejagnu

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/autoconf-2.13-consolidated_fixes-1.patch

NAME=autoconf213
VERSION=2.13
URL=https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz

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

patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch &&
mv -v autoconf.texi autoconf213.texi &&
rm -v autoconf.info &&
./configure --prefix=/usr --program-suffix=2.13 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 autoconf213.info /usr/share/info &&
install-info --info-dir=/usr/share/info autoconf213.info
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
