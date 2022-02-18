#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:freetype2


cd $SOURCE_DIR

NAME=grub-efi
VERSION=2.06
URL=https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz
SECTION="File Systems and Disk Management"
DESCRIPTION="The GRUB package provides GRand Unified Bootloader. In this page it will be built with UEFI support, which is not enabled for GRUB built in LFS."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz
wget -nc https://unifoundry.com/pub/unifont/unifont-14.0.01/font-builds/unifont-14.0.01.pcf.gz


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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-14.0.01.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

unset {C,CPP,CXX,LD}FLAGS
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --disable-werror     &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd