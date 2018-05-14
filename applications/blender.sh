#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="blender_2.77.a+dfsg.orig"
VERSION="0"

#REQ:fonts-dejavu
#REQ:ffmpeg
#REQ:boost
#REQ:libfftw3
#REQ:freetype2
#REQ:fontconfig
#REQ:mesa
#REQ:libglew
#REQ:glu
#REQ:ilmbase
#REQ:jack2
#REQ:jemalloc
#REQ:libjpeg
#REQ:openal-soft
#REQ:openexr
#REQ:opencolorio
#REQ:openimageio
#REQ:openjpeg
#REQ:libpng
#REQ:python2
#REQ:libsndfile
#REQ:libspnav
#REQ:tbb
#REQ:libtiff
#REQ:xserver-meta

URL=http://archive.ubuntu.com/ubuntu/pool/universe/b/blender/blender_2.77.a+dfsg0.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir -pv build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/blender-2.77	\
-DWITH_PLAYER=ON 			\
-DWITH_OPENCOLLADA=ON 			\
-DWITH_FFTW3=ON 			\
-DWITH_INPUT_NDOF=ON 			\
-DWITH_OPENCOLORIO=ON 			\
-DWITH_OPENVDB=ON			\
-DWITH_MEM_VALGRIND=ON			\
-DWITH_SYSTEM_OPENJPEG=ON		\
-DWITH_SDL=ON				\
-DWITH_SDL_DYNLOAD=ON			\
-DWITH_JACK=ON				\
-DWITH_JACK_DYNLOAD=ON			\
-DWITH_CODEC_FFMPEG=ON			\
-DWITH_CODEC_SNDFILE=ON			\
-DWITH_PYTHON_INSTALL_NUMPY=ON		\
-DWITH_PYTHON_SAFETY=ON			\
-DWITH_MOD_OCEANSIM=ON			\
	.. &&
make "-j`nproc`"
sudo make install
sudo ln -svf /opt/blender-2.77/blender.desktop /usr/share/applications/
sudo tee /etc/profile.d/blender.sh <<"EOF"
pathappend /opt/blender-2.77
EOF

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
