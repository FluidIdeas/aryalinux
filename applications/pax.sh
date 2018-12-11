#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cpio

cd $SOURCE_DIR


URL=""

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

gzip -dck paxmirabilis-20161104.cpio.gz | cpio -mid &&
cd pax &&

sed -i '/stat.h/a #include <sys/sysmacros.h>' cpio.c gen_subs.c tar.c &&

cc -O2 -DLONG_OFF_T -o pax -DPAX_SAFE_PATH=\"/bin\" *.c

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v pax /bin &&
install -v pax.1 /usr/share/man/man1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
