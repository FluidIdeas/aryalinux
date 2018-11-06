#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=1.17.1
NAME="python-modules#pycairo"

#REQ:cairo
#OPT:python2


cd $SOURCE_DIR

URL=https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz

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

python2 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python2 setup.py install --optimize=1   &&
python2 setup.py install_pycairo_header &&
python2 setup.py install_pkgconfig
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


python3 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1   &&
python3 setup.py install_pycairo_header &&
python3 setup.py install_pkgconfig
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
