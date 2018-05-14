#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak pax is an archiving utilitybr3ak created by POSIX and defined by the POSIX.1-2001 standard. Ratherbr3ak than sort out the incompatible options that have crept up betweenbr3ak tar and cpio, along with their implementations acrossbr3ak various versions of UNIX, the IEEE designed a new archive utility.br3ak The name “<span class=\"quote\">pax” is an acronymbr3ak for portable archive exchange. Furthermore, “<span class=\"quote\">pax” means “<span class=\"quote\">peace” in Latin, so its name implies that itbr3ak shall create peace between the tarbr3ak and cpio format supporters. Thebr3ak command invocation and command structure is somewhat a unificationbr3ak of both tar and cpio.br3ak"
SECTION="general"
VERSION=20161104
NAME="pax"

#REQ:cpio


cd $SOURCE_DIR

URL=http://pub.allbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20161104.cpio.gz

if [ ! -z $URL ]
then
wget -nc http://pub.allbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20161104.cpio.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pax/paxmirabilis-20161104.cpio.gz

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

gzip -dck paxmirabilis-20161104.cpio.gz | cpio -mid &&
cd pax &&
sed -i '/stat.h/a #include <sys/sysmacros.h>' cpio.c gen_subs.c tar.c &&
cc -O2 -DLONG_OFF_T -o pax -DPAX_SAFE_PATH=\"/bin\" *.c



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v pax /bin &&
install -v pax.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
