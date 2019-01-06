#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:apr-util
#REQ:scons
#OPT:mitkrb

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2

NAME=serf
VERSION=1.3.9.
URL=https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -i "/Append/s:RPATH=libdir,::" SConstruct &&
sed -i "/Default/s:lib_static,::" SConstruct &&
sed -i "/Alias/s:install_static,::" SConstruct &&
sed -i "/ print/{s/print/print(/; s/$/)/}" SConstruct &&

scons PREFIX=/usr

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
scons PREFIX=/usr install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
