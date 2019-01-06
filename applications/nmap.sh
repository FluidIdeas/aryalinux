#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:libpcap
#REC:pcre
#REC:liblinear
#OPT:pygtk
#OPT:python2
#OPT:subversion
#OPT:libssh2

cd $SOURCE_DIR

wget -nc http://nmap.org/dist/nmap-7.70.tar.bz2

NAME=nmap
VERSION=7.70.
URL=http://nmap.org/dist/nmap-7.70.tar.bz2

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

./configure --prefix=/usr --with-liblua=included &&
make
sed -i 's/lib./lib/' zenmap/test/run_tests.py

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
