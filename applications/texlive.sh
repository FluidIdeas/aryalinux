#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gs
#REQ:fontconfig
#REQ:freetype2
#REQ:gc
#REQ:graphite2
#REQ:harfbuzz
#REQ:icu
#REQ:libpaper
#REQ:libpng
#REQ:poppler
#REQ:tex-path
#REQ:python2
#REQ:ruby
#REQ:tk


cd $SOURCE_DIR

wget -nc ftp://tug.org/texlive/historic/2020/texlive-20200406-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2020/texlive-20200406-texmf.tar.xz
wget -nc ftp://tug.org/texlive/historic/2020/texlive-20200406-tlpdb-full.tar.gz


NAME=texlive
VERSION=2020040
URL=ftp://tug.org/texlive/historic/2020/texlive-20200406-source.tar.xz
SECTION="Typesetting"
DESCRIPTION="Most of TeX Live can be built from source without a pre-existing installation, but xindy (for indexing) needs working versions of latex and pdflatex when configure is run, and the testsuite and install for asy (for vector graphics) will fail if TeX has not already been installed. Additionally, biber is not provided within the texlive source and the version of dvisvgm in the texlive tree cannot be built if shared system libraries are used."

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
# Begin texlive 2020 addition

/opt/texlive/2020/lib

# End texlive 2020 addition
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

SYSPOP= &&
MYPOPPLER_MAJOR=$(pkg-config --modversion poppler | cut -d '.' -f1)
if [ "$MYPOPPLER_MAJOR" = "0" ]; then
    # if major was >=20, minor could start with 0 and not fit in octal
    # causing error from 'let' in bash.
    let MYPOPPLER_MINOR=$(pkg-config --modversion poppler | cut -d '.' -f2)
else
    # force a value > 85
    let MYPOPPLER_MINOR=99
fi
if [ "$MYPOPPLER_MINOR" -lt 85 ]; then
    # BLFS-9.1 uses 0.85.0, ignore earlier versions in this script.
    # If updating texlive on an older system, review the available
    # variants for pdftoepdf and pdftosrc to use system poppler.
    SYSPOP=
else
    SYSPOP="--with-system-poppler --with-system-xpdf"
    if [ "$MYPOPPLER_MINOR" -lt 86 ]; then
        mv -v texk/web2c/pdftexdir/pdftoepdf{-poppler0.83.0,}.cc
    else # 0.86.0 or later, including 20.08.0.
        mv -v texk/web2c/pdftexdir/pdftoepdf{-poppler0.86.0,}.cc
    fi
    # For pdftosrc BLFS-9.1 uses 0.83.0 and that is the latest variant.
    mv -v texk/web2c/pdftexdir/pdftosrc{-poppler0.83.0,}.cc
fi &&
export SYSPOP &&
unset MYPOPPLER_{MAJOR,MINOR}
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

mkdir texlive-build &&
cd texlive-build    &&

../configure                                                    \
    --prefix=/opt/texlive/2020                                  \
    --bindir=/opt/texlive/2020/bin/$TEXARCH                     \
    --datarootdir=/opt/texlive/2020                             \
    --includedir=/opt/texlive/2020/include                      \
    --infodir=/opt/texlive/2020/texmf-dist/doc/info             \
    --libdir=/opt/texlive/2020/lib                              \
    --mandir=/opt/texlive/2020/texmf-dist/doc/man               \
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
    ${SYSPOP}                                                   \
    --with-system-zlib                                          \
    --with-banner-add=" - BLFS" &&

make &&
unset SYSPOP
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2020/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2020/tlpkg/TeXLive/ &&
tar -xf ../../texlive-20200406-tlpdb-full.tar.gz -C /opt/texlive/2020/tlpkg
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../../texlive-20200406-texmf.tar.xz -C /opt/texlive/2020 --strip-components=1
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

