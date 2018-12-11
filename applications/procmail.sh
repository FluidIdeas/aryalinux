#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:mail

cd $SOURCE_DIR

wget -nc http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/procmail-3.22-consolidated_fixes-1.patch

URL=http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
sed -i 's/getline/get_line/' src/*.[ch]                   &&
patch -Np1 -i ../procmail-3.22-consolidated_fixes-1.patch &&

make LOCKINGTEST=/tmp MANDIR=/usr/share/man install       &&
make install-suid
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
