#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gs
#REQ:installing
#REQ:fontconfig
#REQ:freetype2
#REQ:gc
#REQ:graphite2
#REQ:harfbuzz
#REQ:icu
#REQ:libpaper
#REQ:libpng
#REQ:tex-path
#REQ:python2
#REQ:ruby
#REQ:tk


cd $SOURCE_DIR

wget -nc ftp://tug.org/texlive/historic/2019/texlive-20190410-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2019/texlive-20190410-texmf.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20190410-source-upstream_fixes-1.patch


NAME=texlive
VERSION=2019041
URL=ftp://tug.org/texlive/historic/2019/texlive-20190410-source.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2019 addition

/opt/texlive/2019/lib

# End texlive 2019 addition
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

patch -Np1 -i ../texlive-20190410-source-upstream_fixes-1.patch &&

mkdir texlive-build &&
cd texlive-build    &&

../configure                                                    \
    --prefix=/opt/texlive/2019                                  \
    --bindir=/opt/texlive/2019/bin/$TEXARCH                     \
    --datarootdir=/opt/texlive/2019                             \
    --includedir=/opt/texlive/2019/include                      \
    --infodir=/opt/texlive/2019/texmf-dist/doc/info             \
    --libdir=/opt/texlive/2019/lib                              \
    --mandir=/opt/texlive/2019/texmf-dist/doc/man               \
    --disable-native-texlive-build                              \
    --disable-static --enable-shared                            \
    --disable-dvisvgm                                           \
    --with-system-cairo                                         \
    --with-system-fontconfig                                    \
    --with-system-freetype2                                     \
    --with-system-gmp                                           \
    --with-system-graphite2                                     \
    --with-system-harfbuzz                                      \
    --with-system-icu                                           \
    --with-system-libgs                                         \
    --with-system-libpaper                                      \
    --with-system-libpng                                        \
    --with-system-mpfr                                          \
    --with-system-pixman                                        \
    --with-system-zlib                                          \
    --with-banner-add=" - BLFS" &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2019/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2019/tlpkg/TeXLive/
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../../texlive-20190410-texmf.tar.xz -C /opt/texlive/2019 --strip-components=1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

