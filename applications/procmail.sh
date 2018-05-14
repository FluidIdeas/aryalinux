#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Procmail package contains anbr3ak autonomous mail processor. This is useful for filtering and sortingbr3ak incoming mail.br3ak"
SECTION="basicnet"
VERSION=3.22
NAME="procmail"



cd $SOURCE_DIR

URL=http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/procmail/procmail-3.22.tar.gz || wget -nc ftp://ftp.informatik.rwth-aachen.de/pub/packages/procmail/procmail-3.22.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/procmail-3.22-consolidated_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/procmail/procmail-3.22-consolidated_fixes-1.patch

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
sed -i 's/getline/get_line/' src/*.[ch]                   &&
patch -Np1 -i ../procmail-3.22-consolidated_fixes-1.patch &&
make LOCKINGTEST=/tmp MANDIR=/usr/share/man install       &&
make install-suid

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
