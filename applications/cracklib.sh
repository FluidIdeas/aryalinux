#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The CrackLib package contains abr3ak library used to enforce strong passwords by comparing user selectedbr3ak passwords to words in chosen word lists.br3ak"
SECTION="postlfs"
VERSION=2.9.6
NAME="cracklib"

#OPT:python2


cd $SOURCE_DIR

URL=https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cracklib/cracklib-2.9.6.tar.gz
wget -nc https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cracklib-words/cracklib-words-2.9.6.gz

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

sed -i '/skipping/d' util/packer.c &&
./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                      &&
mv -v /usr/lib/libcrack.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libcrack.so) /usr/lib/libcrack.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 -D    ../cracklib-words-2.9.6.gz \
                         /usr/share/dict/cracklib-words.gz     &&
gunzip -v                /usr/share/dict/cracklib-words.gz     &&
ln -v -sf cracklib-words /usr/share/dict/words                 &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      /lib/cracklib                         &&
create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


make test




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
