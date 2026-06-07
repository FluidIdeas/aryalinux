#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=zsh
VERSION=5.9
URL=https://www.zsh.org/pub/zsh-5.9.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.zsh.org/pub/zsh-5.9.tar.xz


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

sed -e 's/set_from_init_file/texinfo_&/' \
    -i Doc/Makefile.in
sed -e 's/^main/int &/'      \
    -e 's/exit(/return(/'    \
    -i aczsh.m4 configure.ac
sed -e 's/test = /&(char**)/' \
    -i configure.ac
autoconf
sed -e 's|/etc/z|/etc/zsh/z|g' \
    -i Doc/*.*
./configure --prefix=/usr            \
            --sysconfdir=/etc/zsh    \
            --enable-etcdir=/etc/zsh \
            --enable-cap             \
            --enable-gdbm
make
makeinfo  Doc/zsh.texi --html      -o Doc/html
makeinfo  Doc/zsh.texi --plaintext -o zsh.txt
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o zsh.html
texi2pdf  Doc/zsh.texi -o Doc/zsh.pdf
make infodir=/usr/share/info install.info
make htmldir=/usr/share/doc/zsh-5.9/html install.html
cat >> /etc/shells << "EOF"
/bin/zsh
EOF


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m644 zsh.{html,txt} Etc/FAQ /usr/share/doc/zsh-5.9
install -v -m644 Doc/zsh.pdf /usr/share/doc/zsh-5.9
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd