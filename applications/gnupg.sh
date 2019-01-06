#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libassuan
#REQ:libgcrypt
#REQ:libgpg-error
#REQ:libksba
#REQ:npth
#REC:pinentry
#OPT:curl
#OPT:gnutls
#OPT:imagemagick
#OPT:libusb-compat
#OPT:mail
#OPT:openldap
#OPT:sqlite
#OPT:texlive
#OPT:tl-installer

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.12.tar.bz2

NAME=gnupg
VERSION=2.2.12.
URL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.12.tar.bz2

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

sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
    -i tools/Makefile.in
./configure --prefix=/usr            \
            --enable-symcryptrun     \
            --docdir=/usr/share/doc/gnupg-2.2.12 &&
make &&

makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi
make -C doc pdf ps html

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&

install -v -m755 -d /usr/share/doc/gnupg-2.2.12/html            &&
install -v -m644    doc/gnupg_nochunks.html \
                    /usr/share/doc/gnupg-2.2.12/html/gnupg.html &&
install -v -m644    doc/*.texi doc/gnupg.txt \
                    /usr/share/doc/gnupg-2.2.12
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 doc/gnupg.html/* \
                 /usr/share/doc/gnupg-2.2.12/html &&
install -v -m644 doc/gnupg.{pdf,dvi,ps} \
                 /usr/share/doc/gnupg-2.2.12
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
