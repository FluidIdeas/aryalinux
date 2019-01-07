#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:xcursor-themes

cd $SOURCE_DIR


NAME=x7font
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

cat > font-7.md5 << "EOF"
23756dab809f9ec5011bb27fb2c3c7d6 font-util-1.3.1.tar.bz2
0f2d6546d514c5cc4ecf78a60657a5c1 encodings-1.0.4.tar.bz2
6d25f64796fef34b53b439c2e9efa562 font-alias-1.0.3.tar.bz2
fcf24554c348df3c689b91596d7f9971 font-adobe-utopia-type1-1.0.4.tar.bz2
e8ca58ea0d3726b94fe9f2c17344be60 font-bh-ttf-1.0.3.tar.bz2
53ed9a42388b7ebb689bdfc374f96a22 font-bh-type1-1.0.3.tar.bz2
bfb2593d2102585f45daa960f43cb3c4 font-ibm-type1-1.0.3.tar.bz2
6306c808f7d7e7d660dfb3859f9091d2 font-misc-ethiopic-1.0.3.tar.bz2
3eeb3fb44690b477d510bbd8f86cf5aa font-xfree86-type1-1.0.4.tar.bz2
EOF
mkdir font &&
cd font &&
grep -v '^#' ../font-7.md5 | awk '{print $2}' | wget -i- -c \
-B https://www.x.org/pub/individual/font/ &&
md5sum -c ../font-7.md5
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
bash -e
for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
do
packagedir=${package%.tar.bz2}
tar -xf $package
pushd $packagedir
./configure $XORG_CONFIG
make
as_root make install
popd
as_root rm -rf $packagedir
done
exit

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/fonts &&
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF &&
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
