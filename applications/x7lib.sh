#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:fontconfig
#REQ:libxcb
#OPT:xmlto
#OPT:fop
#OPT:links
#OPT:lynx
#OPT:w3m

cd $SOURCE_DIR


URL=""

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

cat > lib-7.md5 << "EOF"
<code class="literal">c5ba432dd1514d858053ffe9f4737dd8 xtrans-1.3.5.tar.bz2 034fdd6cc5393974d88aec6f5bc96162 libX11-1.6.7.tar.bz2 52df7c4c1f0badd9f82ab124fb32eb97 libXext-1.3.3.tar.bz2 d79d9fe2aa55eb0f69b1a4351e1368f7 libFS-1.0.7.tar.bz2 addfb1e897ca8079531669c7c7711726 libICE-1.0.9.tar.bz2 87c7fad1c1813517979184c8ccd76628 libSM-1.2.3.tar.bz2 eeea9d5af3e6c143d0ea1721d27a5e49 libXScrnSaver-1.2.3.tar.bz2 8f5b5576fbabba29a05f3ca2226f74d3 libXt-1.1.5.tar.bz2 41d92ab627dfa06568076043f3e089e4 libXmu-1.1.2.tar.bz2 20f4627672edb2bd06a749f11aa97302 libXpm-3.5.12.tar.bz2 e5e06eb14a608b58746bdd1c0bd7b8e3 libXaw-1.0.13.tar.bz2 07e01e046a0215574f36a3aacb148be0 libXfixes-5.0.3.tar.bz2 f7a218dcbf6f0848599c6c36fc65c51a libXcomposite-0.4.4.tar.bz2 802179a76bded0b658f4e9ec5e1830a4 libXrender-0.9.10.tar.bz2 58fe3514e1e7135cf364101e714d1a14 libXcursor-1.1.15.tar.bz2 0cf292de2a9fa2e9a939aefde68fd34f libXdamage-1.1.4.tar.bz2 0920924c3a9ebc1265517bdd2f9fde50 libfontenc-1.1.3.tar.bz2 b7ca87dfafeb5205b28a1e91ac3efe85 libXfont2-2.0.3.tar.bz2 331b3a2a3a1a78b5b44cfbd43f86fcfe libXft-2.3.2.tar.bz2 1f0f2719c020655a60aee334ddd26d67 libXi-1.7.9.tar.bz2 0d5f826a197dae74da67af4a9ef35885 libXinerama-1.1.4.tar.bz2 28e486f1d491b757173dd85ba34ee884 libXrandr-1.5.1.tar.bz2 5d6d443d1abc8e1f6fc1c57fb27729bb libXres-1.2.0.tar.bz2 ef8c2c1d16a00bd95b9fdcef63b8a2ca libXtst-1.2.3.tar.bz2 210b6ef30dda2256d54763136faa37b9 libXv-1.0.11.tar.bz2 4cbe1c1def7a5e1b0ed5fce8e512f4c6 libXvMC-1.0.10.tar.bz2 d7dd9b9df336b7dd4028b6b56542ff2c libXxf86dga-1.1.4.tar.bz2 298b8fff82df17304dfdb5fe4066fe3a libXxf86vm-1.1.4.tar.bz2 d2f1f0ec68ac3932dd7f1d9aa0a7a11c libdmx-1.1.4.tar.bz2 8f436e151d5106a9cfaa71857a066d33 libpciaccess-0.14.tar.bz2 4a4cfeaf24dab1b991903455d6d7d404 libxkbfile-1.0.9.tar.bz2 42dda8016943dc12aff2c03a036e0937 libxshmfence-1.3.tar.bz2</code>
EOF
mkdir lib &&
cd lib &&
grep -v '^#' ../lib-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/lib/ &&
md5sum -c ../lib-7.md5
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
grep -A9 summary *make_check.log
bash -e
for package in $(grep -v '^#' ../lib-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
  case $packagedir in
    libICE* )
      ./configure $XORG_CONFIG ICE_LIBS=-lpthread
    ;;

    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG --disable-devel-docs
    ;;

    libXt-[0-9]* )
      ./configure $XORG_CONFIG \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;

    * )
      ./configure $XORG_CONFIG
    ;;
  esac
  make
  #make check 2>&1 | tee ../$packagedir-make_check.log
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done
exit

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ln -sv $XORG_PREFIX/lib/X11 /usr/lib/X11 &&
ln -sv $XORG_PREFIX/include/X11 /usr/include/X11
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
