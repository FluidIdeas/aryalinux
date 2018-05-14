#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libxslt package contains XSLTbr3ak libraries used for extending <code class=\"filename\">libxml2br3ak libraries to support XSLT files.br3ak"
SECTION="general"
VERSION=1.1.32
NAME="libxslt"

#REQ:libxml2
#REC:docbook
#REC:docbook-xsl
#OPT:libgcrypt
#OPT:python-modules#libxml2py2


cd $SOURCE_DIR

URL=http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz

if [ ! -z $URL ]
then
wget -nc http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.32.tar.gz || wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.32.tar.gz

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

sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
./configure --prefix=/usr --disable-static                   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
