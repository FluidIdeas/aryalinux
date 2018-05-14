#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Most of TeX Live can be built from source without a pre-existingbr3ak installation, but xindy (forbr3ak indexing) needs working versions of <span class=\"command\"><strong>latex</strong> and <span class=\"command\"><strong>pdflatex</strong> when configure is run,br3ak and the testsuite and install for <span class=\"command\"><strong>asy</strong> (for vector graphics) willbr3ak fail if TeX has not already been installed. Additionally,br3ak biber is not provided within thebr3ak texlive source.br3ak"
SECTION="pst"
VERSION=20170524
NAME="texlive"

#REC:gs
#REC:asymptote
#REC:fontconfig
#REC:freetype2
#REC:gc
#REC:graphite2
#REC:harfbuzz
#REC:icu
#REC:libpaper
#REC:libpng
#REC:poppler
#REC:python2
#REC:ruby
#REC:tk
#REC:xorg-server


cd $SOURCE_DIR

URL=ftp://tug.org/texlive/historic/2017/texlive-20170524-source.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://tug.org/texlive/historic/2017/texlive-20170524-source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20170524-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2017/texlive-20170524-texmf.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/texlive/texlive-20170524-texmf.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20170524-source-gcc7-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20170524-source-gcc7-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20170524-source-upstream_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20170524-source-upstream_fixes-2.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20170524-source-poppler059-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20170524-source-poppler059-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/texlive-20170524-texmf-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/texlive/texlive-20170524-texmf-upstream_fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2017 addition
/opt/texlive/2017/lib
# End texlive 2017 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
patch -Np1 -i ../texlive-20170524-source-gcc7-1.patch           &&
patch -Np1 -i ../texlive-20170524-source-upstream_fixes-2.patch &&
patch -Np1 -i ../texlive-20170524-source-poppler059-1.patch     &&
mkdir texlive-build &&
cd texlive-build    &&
../configure                                                    \
    --prefix=/opt/texlive/2017                                  \
    --bindir=/opt/texlive/2017/bin/$TEXARCH                     \
    --datarootdir=/opt/texlive/2017                             \
    --includedir=/opt/texlive/2017/include                      \
    --infodir=/opt/texlive/2017/texmf-dist/doc/info             \
    --libdir=/opt/texlive/2017/lib                              \
    --mandir=/opt/texlive/2017/texmf-dist/doc/man               \
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
    --with-system-poppler                                       \
    --with-system-xpdf                                          \
    --with-system-zlib                                          \
    --with-banner-add=" - BLFS" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2017/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2017/tlpkg/TeXLive/

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../../texlive-20170524-texmf.tar.xz -C /opt/texlive/2017 --strip-components=1 &&
pushd /opt/texlive/2017 &&
patch -Np1 -i /sources/texlive-20170524-texmf-upstream_fixes-1.patch &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
