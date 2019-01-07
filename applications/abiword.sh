#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:boost
#REQ:fribidi
#REQ:goffice010
#REQ:wv
#REC:enchant
#OPT:dbus-glib
#OPT:gobject-introspection
#OPT:libgcrypt
#OPT:libical
#OPT:libsoup
#OPT:redland
#OPT:valgrind
#OPT:evolution-data-server
#OPT:libchamplain
#OPT:telepathy-glib

cd $SOURCE_DIR

wget -nc http://www.abisource.com/downloads/abiword/3.0.2/source/abiword-3.0.2.tar.gz
wget -nc http://www.abisource.com/downloads/abiword/3.0.2/source/abiword-docs-3.0.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/abiword-3.0.2-gtk3_22_render_fix-1.patch

NAME=abiword
VERSION=3.0.2
URL=http://www.abisource.com/downloads/abiword/3.0.2/source/abiword-3.0.2.tar.gz

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

patch -Np1 -i ../abiword-3.0.2-gtk3_22_render_fix-1.patch &&

sed -e "s/free_suggestions/free_string_list/" \
-e "s/_to_personal//" \
-e "s/in_session/added/" \
-i src/af/xap/xp/enchant_checker.cpp &&

sed -e "/icaltime_from_timet/{s/timet/&_with_zone/;s/0/0, 0/}" \
-i src/text/ptbl/xp/pd_DocumentRDF.cpp &&

./configure --prefix=/usr --without-evolution-data-server &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

tar -xf ../abiword-docs-3.0.2.tar.gz &&
cd abiword-docs-3.0.1 &&
./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

ls /usr/share/abiword-3.0/templates
install -v -m750 -d ~/.AbiSuite/templates &&
install -v -m640 /usr/share/abiword-3.0/templates/normal.awt-<em class="replaceable"><code><lang></code></em> \
~/.AbiSuite/templates/normal.awt

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
