#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:psutils
#REQ:cups


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz
wget -nc http://anduin.linuxfromscratch.org/BLFS/i18n-fonts/i18n-fonts-0.1.tar.bz2


NAME=a2ps
VERSION=4.14
URL=https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz
SECTION="PostScript"
DESCRIPTION="a2ps is a filter utilized mainly in the background and primarily by printing scripts to convert almost every input format into PostScript output. The application's name expands appropriately to “all to PostScript”."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


autoconf &&
sed -i -e "s/GPERF --version |/& head -n 1 |/" \
       -e "s|/usr/local/share|/usr/share|" configure &&

./configure --prefix=/usr  \
    --sysconfdir=/etc/a2ps \
    --enable-shared        \
    --with-medium=letter   &&
make                       &&
touch doc/*.info
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../i18n-fonts-0.1.tar.bz2 &&
cp -v i18n-fonts-0.1/fonts/* /usr/share/a2ps/fonts               &&
cp -v i18n-fonts-0.1/afm/* /usr/share/a2ps/afm                   &&
pushd /usr/share/a2ps/afm    &&
  ./make_fonts_map.sh        &&
  mv fonts.map.new fonts.map &&
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

