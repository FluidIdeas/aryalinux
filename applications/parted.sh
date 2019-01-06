#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:lvm2
#OPT:pth
#OPT:texlive
#OPT:tl-installer

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/parted-3.2-devmapper-1.patch

NAME=parted
VERSION=3.2
URL=https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz

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

patch -Np1 -i ../parted-3.2-devmapper-1.patch
sed -i '/utsname.h/a#include <sys/sysmacros.h>' libparted/arch/linux.c &&

./configure --prefix=/usr --disable-static &&
make &&

make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi
texi2pdf             -o doc/parted.pdf doc/parted.texi &&
texi2dvi             -o doc/parted.dvi doc/parted.texi &&
dvips                -o doc/parted.ps  doc/parted.dvi
sed -i '/t0251-gpt-unicode.sh/d' tests/Makefile

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m755 -d /usr/share/doc/parted-3.2/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.2/html &&
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 doc/FAT doc/API doc/parted.{pdf,ps,dvi} \
                    /usr/share/doc/parted-3.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
