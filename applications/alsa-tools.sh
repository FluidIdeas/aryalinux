#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:alsa-lib
#OPT:gtk2
#OPT:gtk3
#OPT:fltk

cd $SOURCE_DIR

wget -nc ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.7.tar.bz2

NAME=alsa-tools
VERSION=1.1.7
URL=ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.7.tar.bz2

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

as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
bash -e
rm -rf qlo10k1 Makefile gitcompile
for tool in *
do
case $tool in
seq )
tool_dir=seq/sbiload
;;
* )
tool_dir=$tool
;;
esac

pushd $tool_dir
./configure --prefix=/usr
make
as_root make install
as_root /sbin/ldconfig
popd

done
unset tool tool_dir
exit

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
