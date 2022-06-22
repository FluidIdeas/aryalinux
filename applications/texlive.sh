#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gs
#REQ:cairo
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

NAME=texlive
VERSION=2022032
URL=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2022/texlive-20220321-source.tar.xz
SECTION="Typesetting"
DESCRIPTION="According to https://www.tug.org/historic/ the master site in France only supports ftp and rsync. Now that ftp is generally deprecated, that page has links to mirrors, some of which support https, e.g. in Utah and Chemntiz as well as in China. If you prefer to use a different mirror from the example links here, you will need to navigate to systems/historic/texlive/2022 or systems/texlive/2022 as the case may be."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2022/texlive-20220321-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2022/texlive-20220321-source.tar.xz
wget -nc https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2022/texlive-20220321-texmf.tar.xz
wget -nc ftp://tug.org/texlive/historic/2022/texlive-20220321-texmf.tar.xz
wget -nc https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2022/texlive-20220325-tlpdb-full.tar.gz
wget -nc ftp://tug.org/texlive/historic/2022/texlive-20220325-tlpdb-full.tar.gz


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
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2022 addition

/opt/texlive/2022/lib

# End texlive 2022 addition
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

export TEXARCH=$(uname -m |
 sed -e 's/i.86/i386/' -e 's/$/-linux/')                 &&

mkdir texlive-build &&
cd texlive-build    &&

../configure                                        \
    --prefix=/opt/texlive/2022                      \
    --bindir=/opt/texlive/2022/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2022                 \
    --includedir=/opt/texlive/2022/include          \
    --infodir=/opt/texlive/2022/texmf-dist/doc/info \
    --libdir=/opt/texlive/2022/lib                  \
    --mandir=/opt/texlive/2022/texmf-dist/doc/man   \
    --disable-native-texlive-build                  \
    --disable-static --enable-shared                \
    --disable-dvisvgm                               \
    --with-system-cairo                             \
    --with-system-fontconfig                        \
    --with-system-freetype2                         \
    --with-system-gmp                               \
    --with-system-graphite2                         \
    --with-system-harfbuzz                          \
    --with-system-icu                               \
    --with-system-libgs                             \
    --with-system-libpaper                          \
    --with-system-libpng                            \
    --with-system-mpfr                              \
    --with-system-pixman                            \
    --with-system-zlib                              \
    --with-banner-add=" - BLFS" &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2022/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2022/tlpkg/TeXLive/ &&
tar -xf ../../texlive-20220325-tlpdb-full.tar.gz -C /opt/texlive/2022/tlpkg
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../../texlive-20220321-texmf.tar.xz -C /opt/texlive/2022 --strip-components=1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
for F in /opt/texlive/2022/texmf-dist/scripts/latex-make/*.py ; do
  sed -i 's%/usr/bin/env python%/usr/bin/python3%' $F
done
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

popd