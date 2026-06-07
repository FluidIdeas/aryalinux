#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:installing

cd $SOURCE_DIR
NAME=texlive
VERSION=0
URL=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/texlive-20250308-source.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/texlive-20250308-source.tar.xz


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

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/')
patch -Np1 -i ../texlive-20250308-source-upstream_fixes-1.patch
mkdir texlive-build
cd    texlive-build
../configure CC="gcc -std=gnu17" -C               \
    --prefix=$TEXLIVE_PREFIX                      \
    --bindir=$TEXLIVE_PREFIX/bin/$TEXARCH         \
    --datarootdir=$TEXLIVE_PREFIX                 \
    --includedir=$TEXLIVE_PREFIX/include          \
    --infodir=$TEXLIVE_PREFIX/texmf-dist/doc/info \
    --libdir=$TEXLIVE_PREFIX/lib                  \
    --mandir=$TEXLIVE_PREFIX/texmf-dist/doc/man   \
    --disable-native-texlive-build                \
    --disable-static --enable-shared              \
    --disable-dvisvgm                             \
    --with-system-cairo                           \
    --with-system-fontconfig                      \
    --with-system-freetype2                       \
    --with-system-gmp                             \
    --with-system-graphite2                       \
    --with-system-harfbuzz                        \
    --with-system-icu                             \
    --with-system-libpaper                        \
    --with-system-libpng                          \
    --with-system-mpfr                            \
    --with-system-pixman                          \
    --with-system-zlib                            \
    --with-banner-add=" - BLFS"
make
make texlinks
mkdir -pv                                $TEXLIVE_PREFIX/tlpkg/TeXLive/
tar -xf ../../texlive-20250308-extra.tar.xz -C $TEXLIVE_PREFIX/tlpkg --strip-components=2
tar -xf ../../texlive-20250308-texmf.tar.xz -C $TEXLIVE_PREFIX --strip-components=1
mktexlsr
fmtutil-sys --all
ln -svf $TEXLIVE_PREFIX/lib/libkpathsea.so{,.6} /usr/lib


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip
install -v -m644 ../texk/tests/TeXLive/* $TEXLIVE_PREFIX/tlpkg/TeXLive/
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd