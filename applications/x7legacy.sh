#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xcursor-themes

cd $SOURCE_DIR


NAME=x7legacy
VERSION=""
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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > legacy.dat << "EOF"
2a455d3c02390597feb9cefb3fe97a45 app/ bdftopcf-1.1.tar.bz2
1347c3031b74c9e91dc4dfa53b12f143 font/ font-adobe-100dpi-1.0.3.tar.bz2
6c9f26c92393c0756f3e8d614713495b font/ font-adobe-75dpi-1.0.3.tar.bz2
cb7b57d7800fd9e28ec35d85761ed278 font/ font-jis-misc-1.0.3.tar.bz2
0571bf77f8fab465a5454569d9989506 font/ font-daewoo-misc-1.0.3.tar.bz2
a2401caccbdcf5698e001784dbd43f1a font/ font-isas-misc-1.0.3.tar.bz2
EOF
mkdir legacy &&
cd legacy &&
grep -v '^#' ../legacy.dat | awk '{print $2$3}' | wget -i- -c \
-B https://www.x.org/pub/individual/ &&
grep -v '^#' ../legacy.dat | awk '{print $1 " " $3}' > ../legacy.md5 &&
md5sum -c ../legacy.md5
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
bash -e
for package in $(grep -v '^#' ../legacy.md5 | awk '{print $2}')
do
packagedir=${package%.tar.bz2}
tar -xf $package
pushd $packagedir
./configure $XORG_CONFIG
make
as_root make install
popd
rm -rf $packagedir
as_root /sbin/ldconfig
done
exit

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
