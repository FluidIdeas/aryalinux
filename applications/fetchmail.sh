#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:procmail
#OPT:python2
#OPT:tk

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/fetchmail-6.3.26-disable_sslv3-1.patch

NAME=fetchmail
VERSION=6.3.26
URL=https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz

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

patch -Np1 -i ../fetchmail-6.3.26-disable_sslv3-1.patch &&
./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat > ~/.fetchmailrc << "EOF"
<code class="literal">set logfile /var/log/fetchmail.log set no bouncemail set postmaster root poll SERVERNAME : user <em class="replaceable"><code><username></code></em> pass <em class="replaceable"><code><password></code></em>; mda "/usr/bin/procmail -f %F -d %T";</code>
EOF

chmod -v 0600 ~/.fetchmailrc

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
