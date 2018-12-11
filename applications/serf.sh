#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Serf package contains abr3ak C-based HTTP client library built upon the Apache Portable Runtimebr3ak (APR) library. It multiplexes connections, running the read/writebr3ak communication asynchronously. Memory copies and transformations arebr3ak kept to a minimum to provide high performance operation.br3ak"
SECTION="basicnet"
VERSION=1.3.9
NAME="serf"

#REQ:apr-util
#REQ:scons
#OPT:mitkrb


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/serf/serf-1.3.9.tar.bz2

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

sed -i "/Append/s:RPATH=libdir,::"          SConstruct &&
sed -i "/Default/s:lib_static,::"           SConstruct &&
sed -i "/Alias/s:install_static,::"         SConstruct &&
sed -i "/  print/{s/print/print(/; s/$/)/}" SConstruct &&
scons PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
scons PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
