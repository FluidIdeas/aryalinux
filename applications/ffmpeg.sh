#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:dav1d
#REQ:libaom
#REQ:libass
#REQ:freetype2
#REQ:libvorbis
#REQ:libvpx
#REQ:opus
#REQ:x264
#REQ:x265
#REQ:alsa-lib
#REQ:sdl2

cd $SOURCE_DIR
NAME=ffmpeg
VERSION=8.0.1
URL=https://ffmpeg.org/releases/ffmpeg-8.0.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ffmpeg.org/releases/ffmpeg-8.0.1.tar.xz


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

patch -Np1 -i ../ffmpeg-8.0.1-chromium_method-1.patch
sed -e '/adaptive/c\ param->aq_mode = 0;' \
    -i libavcodec/libsvtav1.c
./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libaom      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --enable-openssl     \
            --enable-libdav1d    \
            --enable-libsvtav1   \
            --ignore-tests=enhanced-flv-av1,enhanced-flv-multitrack \
            --docdir=/usr/share/doc/ffmpeg-8.0.1
make
gcc tools/qt-faststart.c -o tools/qt-faststart
pushd doc
for DOCNAME in `basename -s .html *.html`
do
    texi2pdf -b $DOCNAME.texi
texi2dvi -b $DOCNAME.texi
dvips    -o $DOCNAME.ps   \
                $DOCNAME.dvi
done
popd
unset DOCNAME
doxygen doc/Doxyfile
make fate-rsync SAMPLES=fate-suite/
rsync -vrltLW  --delete --timeout=60 --contimeout=60 \
      rsync://fate-suite.ffmpeg.org/fate-suite/ fate-suite/
make fate THREADS=N SAMPLES=fate-suite/ | tee ../fate.log
grep ^TEST ../fate.log | wc -l
cp -vr doc/doxy/html/* /usr/share/doc/ffmpeg-8.0.1/api
find /usr/share/doc/ffmpeg-8.0.1/api -type f -exec chmod -c 0644 \{} \;
find /usr/share/doc/ffmpeg-8.0.1/api -type d -exec chmod -c 0755 \{} \;


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m755    tools/qt-faststart /usr/bin
install -v -m755 -d           /usr/share/doc/ffmpeg-8.0.1
install -v -m644    doc/*.txt /usr/share/doc/ffmpeg-8.0.1
install -v -m644 doc/*.pdf /usr/share/doc/ffmpeg-8.0.1
install -v -m644 doc/*.ps  /usr/share/doc/ffmpeg-8.0.1
install -v -m755 -d /usr/share/doc/ffmpeg-8.0.1/api
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd