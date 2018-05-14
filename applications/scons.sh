#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak SCons is a tool for buildingbr3ak software (and other files) implemented in Python.br3ak"
SECTION="general"
VERSION=3.0.0
NAME="scons"

#REQ:python2
#OPT:docbook-xsl
#OPT:python-modules#libxml2py2
#OPT:libxslt


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/scons/scons-3.0.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/scons/scons-3.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/scons/scons-3.0.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/scons/scons-3.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/scons/scons-3.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/scons/scons-3.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/scons/scons-3.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/scons/scons-3.0.0.tar.gz

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
python setup.py install --prefix=/usr  \
                        --standard-lib \
                        --optimize=1   \
                        --install-data=/usr/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
