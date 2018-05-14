#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The zsh package contains a commandbr3ak interpreter (shell) usable as an interactive login shell and as abr3ak shell script command processor. Of the standard shells,br3ak zsh most closely resemblesbr3ak ksh but includes manybr3ak enhancements.br3ak"
SECTION="postlfs"
VERSION=5.5.1
NAME="zsh"

#OPT:libcap
#OPT:pcre
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.zsh.org/pub/zsh-5.5.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.zsh.org/pub/zsh-5.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.5.1.tar.gz
wget -nc http://www.zsh.org/pub/zsh-5.5.1-doc.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.5.1-doc.tar.xz

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

tar --strip-components=1 -xvf ../zsh-5.5.1-doc.tar.xz


./configure --prefix=/usr         \
            --bindir=/bin         \
            --sysconfdir=/etc/zsh \
            --enable-etcdir=/etc/zsh                  &&
make                                                  &&
makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt     &&
makeinfo  Doc/zsh.texi --html      -o Doc/html        &&
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o Doc/zsh.html


texi2pdf  Doc/zsh.texi -o Doc/zsh.pdf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                              &&
make infodir=/usr/share/info install.info &&
install -v -m755 -d                 /usr/share/doc/zsh-5.5.1/html &&
install -v -m644 Doc/html/*         /usr/share/doc/zsh-5.5.1/html &&
install -v -m644 Doc/zsh.{html,txt} /usr/share/doc/zsh-5.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make htmldir=/usr/share/doc/zsh-5.5.1/html install.html &&
install -v -m644 Doc/zsh.dvi /usr/share/doc/zsh-5.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 Doc/zsh.pdf /usr/share/doc/zsh-5.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libpcre.so.* /lib &&
ln -v -sf ../../lib/libpcre.so.0 /usr/lib/libpcre.so
mv -v /usr/lib/libgdbm.so.* /lib &&
ln -v -sf ../../lib/libgdbm.so.3 /usr/lib/libgdbm.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/shells << "EOF"
/bin/zsh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
