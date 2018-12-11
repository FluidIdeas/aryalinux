#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:libass
#REC:fdk-aac
#REC:freetype2
#REC:lame
#REC:libtheora
#REC:libvorbis
#REC:libvpx
#REC:opus
#REC:x264
#REC:x265
#REC:yasm
#REC:alsa-lib
#REC:x7driver#libva
#REC:x7driver#libvdpau
#REC:sdl2
#OPT:fontconfig
#OPT:frei0r
#OPT:libcdio
#OPT:libwebp
#OPT:opencv
#OPT:openjpeg2
#OPT:gnutls
#OPT:pulseaudio
#OPT:speex
#OPT:texlive
#OPT:tl-installer
#OPT:v4l-utils
#OPT:xvid
#OPT:installing
#OPT:libbluray
#OPT:libdca

cd $SOURCE_DIR

wget -nc http://ffmpeg.org/releases/ffmpeg-4.0.2.tar.xz

URL=http://ffmpeg.org/releases/ffmpeg-4.0.2.tar.xz

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

sed -i 's/-lflite"/-lflite -lasound"/' configure &&

./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-avresample  \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --docdir=/usr/share/doc/ffmpeg-4.0.2 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart
pushd doc &&
for DOCNAME in `basename -s .html *.html`
do
    texi2pdf -b $DOCNAME.texi &&
    texi2dvi -b $DOCNAME.texi &&

    dvips    -o $DOCNAME.ps   \
                $DOCNAME.dvi
done &&
popd &&
unset DOCNAME

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&

install -v -m755    tools/qt-faststart /usr/bin &&
install -v -m755 -d           /usr/share/doc/ffmpeg-4.0.2 &&
install -v -m644    doc/*.txt /usr/share/doc/ffmpeg-4.0.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 doc/*.pdf /usr/share/doc/ffmpeg-4.0.2 &&
install -v -m644 doc/*.ps  /usr/share/doc/ffmpeg-4.0.2
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/doc/ffmpeg-4.0.2/api                     &&
cp -vr doc/doxy/html/* /usr/share/doc/ffmpeg-4.0.2/api                  &&
find /usr/share/doc/ffmpeg-4.0.2/api -type f -exec chmod -c 0644 \{} \; &&
find /usr/share/doc/ffmpeg-4.0.2/api -type d -exec chmod -c 0755 \{} \;
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

make fate-rsync SAMPLES=fate-suite/
<span class="command"><strong>rsync -vrltLW --delete --timeout=60 --contimeout=60 \ rsync://fate-suite.ffmpeg.org/fate-suite/ fate-suite/</strong></span>
make fate THREADS=<em class="replaceable"><code>N</code></em> SAMPLES=fate-suite/ | tee ../fate.log &&
grep ^TEST ../fate.log | wc -l

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
