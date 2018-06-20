#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Mutt package contains a Mailbr3ak User Agent. This is useful for reading, writing, replying to,br3ak saving, and deleting your email.br3ak"
SECTION="basicnet"
VERSION=1.10.0
NAME="mutt"

#OPT:aspell
#OPT:cyrus-sasl
#OPT:gdb
#OPT:gnupg
#OPT:gpgme
#OPT:libidn
#OPT:mitkrb
#OPT:slang
#OPT:gnutls
#OPT:db
#OPT:libxslt
#OPT:lynx
#OPT:w3m
#OPT:docbook-dsssl
#OPT:openjade
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.mutt.org/pub/mutt/mutt-1.10.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.mutt.org/pub/mutt/mutt-1.10.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mutt/mutt-1.10.0.tar.gz || wget -nc ftp://ftp.mutt.org/pub/mutt/mutt-1.10.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 34 mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chgrp -v mail /var/mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i 's/\(pdfjadetex manual.tex;\)/\1 \1 \1/' doc/Makefile.in


cp -v doc/manual.txt{,.shipped} &&
./configure --prefix=/usr                           \
            --sysconfdir=/etc                       \
            --with-docdir=/usr/share/doc/mutt-1.10.0 \
            --with-ssl                              \
            --enable-external-dotlock               \
            --enable-pop                            \
            --enable-imap                           \
            --enable-hcache                         \
            --enable-sidebar                        &&
make &&


make -C doc manual.pdf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
test -s doc/manual.txt ||
  install -v -m644 doc/manual.txt.shipped \
  /usr/share/doc/mutt-1.10.0/manual.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 doc/manual.pdf \
    /usr/share/doc/mutt-1.10.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


chown root:mail /usr/bin/mutt_dotlock &&
chmod -v 2755 /usr/bin/mutt_dotlock


cat /usr/share/doc/mutt-1.10.0/samples/gpg.rc >> ~/.muttrc




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
