#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Newt is a programming library forbr3ak color text mode, widget based user interfaces. It can be used tobr3ak add stacked windows, entry widgets, checkboxes, radio buttons,br3ak labels, plain text fields, scrollbars, etc., to text mode userbr3ak interfaces. Newt is based on thebr3ak S-Lang library.br3ak"
SECTION="general"
VERSION=0.52.20
NAME="newt"

#REQ:popt
#REQ:slang
#REC:tcl
#REC:gpm
#OPT:python2


cd $SOURCE_DIR

URL=https://releases.pagure.org/newt/newt-0.52.20.tar.gz

if [ ! -z $URL ]
then
wget -nc https://releases.pagure.org/newt/newt-0.52.20.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/newt/newt-0.52.20.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/newt/newt-0.52.20.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.20.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/newt/newt-0.52.20.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.20.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/newt/newt-0.52.20.tar.gz

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

sed -e 's/^LIBNEWT =/#&/' \
    -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
    -i Makefile.in                           &&
./configure --prefix=/usr --with-gpm-support &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
