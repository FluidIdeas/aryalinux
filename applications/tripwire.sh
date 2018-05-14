#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tripwire package containsbr3ak programs used to verify the integrity of the files on a givenbr3ak system.br3ak"
SECTION="postlfs"
VERSION=2.4.3.7
NAME="tripwire"



cd $SOURCE_DIR

URL=https://github.com/Tripwire/tripwire-open-source/releases/download/2.4.3.7/tripwire-open-source-2.4.3.7.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/Tripwire/tripwire-open-source/releases/download/2.4.3.7/tripwire-open-source-2.4.3.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tripwire/tripwire-open-source-2.4.3.7.tar.gz

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

sed -e '/^CLOBBER/s/false/true/'         \
    -e 's|TWDB="${prefix}|TWDB="/var|'   \
    -e '/TWMAN/ s|${prefix}|/usr/share|' \
    -e '/TWDOCS/s|${prefix}/doc/tripwire|/usr/share/doc/tripwire-2.4.3.7|' \
    -i installer/install.cfg                               &&
find . -name Makefile.am | xargs                           \
    sed -i 's/^[[:alpha:]_]*_HEADERS.*=/noinst_HEADERS =/' &&
sed '/dist/d' -i man/man?/Makefile.am                      &&
autoreconf -fi                                             &&
./configure --prefix=/usr --sysconfdir=/etc/tripwire       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp -v policy/*.txt /usr/share/doc/tripwire-2.4.3.7

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i -e 's@installer/install.sh@& -n -s <em class="replaceable"><code><site-password></em> -l <em class="replaceable"><code><local-password></em>@' Makefile


sed '/-t 0/,+3d' -i installer/install.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
twadmin --create-polfile --site-keyfile /etc/tripwire/site.key \
    /etc/tripwire/twpol.txt &&
tripwire --init

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tripwire --check > /etc/tripwire/report.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
twprint --print-report -r /var/lib/tripwire/report/<em class="replaceable"><code><report-name.twr></em>

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tripwire --update --twrfile /var/lib/tripwire/report/<em class="replaceable"><code><report-name.twr></em>

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
twadmin --create-polfile /etc/tripwire/twpol.txt &&
tripwire --init

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
