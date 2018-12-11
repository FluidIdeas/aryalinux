#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=2.9.8
NAME="python-modules#libxml2py2"

#REQ:libxml2
#REQ:python2


cd $SOURCE_DIR

URL=http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.8.tar.gz || wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz

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

cd python             &&
python setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
