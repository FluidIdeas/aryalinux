#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:gs
#REC:asymptote
#REC:installing
#REC:fontconfig
#REC:freetype2
#REC:gc
#REC:graphite2
#REC:harfbuzz
#REC:icu
#REC:libpaper
#REC:libpng
#REC:poppler
#REC:potrace
#REC:python2
#REC:ruby
#REC:tk

cd $SOURCE_DIR

wget -nc ftp://tug.org/texlive/historic/2018/texlive-20180414-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2018/texlive-20180414-texmf.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20180414-source-upstream_fixes-2.patch
wget -nc https://cpan.metacpan.org/authors/id/S/SR/SREZIC/Tk-804.034.tar.gz

NAME=texlive
VERSION=20180414-source
URL=ftp://tug.org/texlive/historic/2018/texlive-20180414-source.tar.xz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/ld.so.conf << EOF
<code class="literal"># Begin texlive 2018 addition /opt/texlive/2018/lib # End texlive 2018 addition</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

patch -Np1 -i ../texlive-20180414-source-upstream_fixes-2.patch &&

mkdir texlive-build &&
cd texlive-build    &&

../configure                                                    \
    --prefix=/opt/texlive/2018                                  \
    --bindir=/opt/texlive/2018/bin/$TEXARCH                     \
    --datarootdir=/opt/texlive/2018                             \
    --includedir=/opt/texlive/2018/include                      \
    --infodir=/opt/texlive/2018/texmf-dist/doc/info             \
    --libdir=/opt/texlive/2018/lib                              \
    --mandir=/opt/texlive/2018/texmf-dist/doc/man               \
    --disable-native-texlive-build                              \
    --disable-static --enable-shared                            \
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
    --with-system-potrace                                       \
    --with-system-zlib                                          \
    --with-banner-add=" - BLFS" &&

make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2018/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2018/tlpkg/TeXLive/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
tar -xf ../../texlive-20180414-texmf.tar.xz -C /opt/texlive/2018 --strip-components=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
