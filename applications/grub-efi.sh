#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:freetype2


cd $SOURCE_DIR

NAME=grub-efi
VERSION=2.0
URL=https://alpha.gnu.org/gnu/grub/grub-2.06~rc1.tar.xz
SECTION="File Systems and Disk Management"
DESCRIPTION="The GRUB package provides GRand Unified Bootloader. In this page it will be built with UEFI support, which is not enabled for GRUB built in LFS."


mkdir -pv $NAME
pushd $NAME

wget -nc https://alpha.gnu.org/gnu/grub/grub-2.06~rc1.tar.xz
wget -nc https://unifoundry.com/pub/unifont/unifont-13.0.06/font-builds/unifont-13.0.06.pcf.gz


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
gunzip -c unifont-13.0.06.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

unset {C,CPP,CXX,LD}FLAGS
./configure --prefix=/usr        \
            --sbindir=/sbin      \
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