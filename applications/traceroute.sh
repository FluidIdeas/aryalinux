#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz

NAME=traceroute
VERSION=2.1.0
URL=https://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz

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

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make prefix=/usr install &&
mv /usr/bin/traceroute /bin &&
ln -sv -f traceroute /bin/traceroute6 &&
ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 &&
rm -fv /usr/share/man/man1/traceroute.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
