#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Opal package contains a C++br3ak class library for normalising the numerous telephony protocols intobr3ak a single integrated call model.br3ak"
SECTION="multimedia"
VERSION=3.10.10
NAME="opal"

#REQ:ptlib
#OPT:ffmpeg
#OPT:libtheora
#OPT:openjdk
#OPT:ruby
#OPT:speex
#OPT:x264


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/opal-3.10.10-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/opal/opal-3.10.10-ffmpeg2-1.patch

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

sed -i 's| abs(| std::fabs(|g' plugins/video/common/mpi.cxx


patch -Np1 -i ../opal-3.10.10-ffmpeg2-1.patch &&
sed -e 's/CODEC_ID/AV_&/' \
    -e 's/PIX_FMT_/AV_&/' \
    -i plugins/video/H.263-1998/h263-1998.cxx \
       plugins/video/common/dyna.cxx          \
       plugins/video/H.264/h264-x264.cxx      \
       plugins/video/MPEG4-ffmpeg/mpeg4.cxx   &&
sed -e '/<< mime.PrintContents/ s/mime/(const std::string\&)&/' \
    -i src/im/msrp.cxx  &&
sed -e '/abs(/s/MPI.*)/(int)(&)/' \
    -i ./plugins/video/common/mpi.cxx &&
./configure --prefix=/usr &&
CXXFLAGS=-Wno-deprecated-declarations make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 644 /usr/lib/libopal_s.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
