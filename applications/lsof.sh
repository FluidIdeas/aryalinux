#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libtirpc

cd $SOURCE_DIR

wget -nc ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.gz

NAME=lsof
VERSION=""
URL=ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.gz

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

tar -xf lsof_4.91_src.tar  &&
cd lsof_4.91_src           &&
./Configure -n linux       &&
make CFGL="-L./lib -ltirpc"

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m0755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
