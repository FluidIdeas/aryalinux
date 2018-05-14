#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde"
NAME="krameworks5"

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:openssl10
#REQ:qtwebkit5
#REQ:phonon
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt
#OPT:bluez
#OPT:ModemManager
#OPT:TTF-and-OTF-fonts#oxygen-fonts
#OPT:TTF-and-OTF-fonts#noto-fonts
#OPT:doxygen
#OPT:python-modules#Jinja2
#OPT:python-modules#PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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

url=http://download.kde.org/stable/frameworks/5.43/
wget -r -nH -nd -A '*.xz' -np $url


cat > frameworks-5.43.0.md5 << "EOF"
bb18451b29c20fc43899003e1b5d88bf attica-5.43.0.tar.xz
#b93c69609dbd2f16f9ee6302020ff5e6 extra-cmake-modules-5.43.0.tar.xz
8f6b6f4c6f11d09692620531baac3cbd kapidox-5.43.0.tar.xz
5d28038e34f01ec59968b3a4732128d5 karchive-5.43.0.tar.xz
b6f2fa4dc1cb75887a401183c6981d26 kcodecs-5.43.0.tar.xz
12298fe985a25fac4ef2fe23cda6f7d8 kconfig-5.43.0.tar.xz
8a7082f64f2f5536b92c9b702e0e6f1b kcoreaddons-5.43.0.tar.xz
9bd2f0271f0d9cf422ab3add939780f6 kdbusaddons-5.43.0.tar.xz
b2257e6bf91f3116839e8c363068c044 kdnssd-5.43.0.tar.xz
29a133ec1b1edf43fdcb64cdc0b3484a kguiaddons-5.43.0.tar.xz
5f67b6d48344d347ca187a038ada4c96 ki18n-5.43.0.tar.xz
6aded894f5a984512e846bf949c6cc56 kidletime-5.43.0.tar.xz
ea24738d89ad19f34df3cea8aebdbcfb kimageformats-5.43.0.tar.xz
4b7ab34387c480efea88daffd6461243 kitemmodels-5.43.0.tar.xz
0212ea41c19ecaf3d8796186a5d7a3d4 kitemviews-5.43.0.tar.xz
a78c532acdb8dbfb6fb07e78fd55bfd0 kplotting-5.43.0.tar.xz
f3d9f489d55e54c5c4047abea6f4477d kwidgetsaddons-5.43.0.tar.xz
ca000f985de0be2bb3c602697d1bb923 kwindowsystem-5.43.0.tar.xz
44a5a63752381bb64876109a421f319a networkmanager-qt-5.43.0.tar.xz
272d83ae231c5e1b5bb2851b730d1a3d solid-5.43.0.tar.xz
366495c4aab66b740a25363c53fde6c2 sonnet-5.43.0.tar.xz
d02fe5fac35d600af14e7cdf5aef04dd threadweaver-5.43.0.tar.xz
8df3fbc742e0914d4f7d3132a34c4017 kauth-5.43.0.tar.xz
a03088f8e53b46169f959c7ff9df1bcf kcompletion-5.43.0.tar.xz
8985aaa68a6e29561423c09df77a3afc kcrash-5.43.0.tar.xz
aec9d49e1bef4aa20151ec06c2fcffe5 kdoctools-5.43.0.tar.xz
5995656593e5f72b591ceb56f5339d24 kpty-5.43.0.tar.xz
5146a71a41c76385cf34544c67005d84 kunitconversion-5.43.0.tar.xz
b3092aca3e241329310ca2c57087a6c6 kconfigwidgets-5.43.0.tar.xz
6ca34186c9f3ffb3e964740ff6ecac55 kservice-5.43.0.tar.xz
4e23296878a567417863a3c88ccf051f kglobalaccel-5.43.0.tar.xz
b7d41f77d01102fef52fab13c25038cb kpackage-5.43.0.tar.xz
9ad92bfb68e7646bc7e4dea2140b348c kdesu-5.43.0.tar.xz
1b860bc5eb70c5c2ee292fb0dc79725d kemoticons-5.43.0.tar.xz
846d45c77c66faeb09769d79665353d4 kiconthemes-5.43.0.tar.xz
81d0d0108fbed55099227c616d88aa1b kjobwidgets-5.43.0.tar.xz
497d0f2f81be5185e4179922ff53b9b7 knotifications-5.43.0.tar.xz
a27bdd565993a82476393a7d840bb851 ktextwidgets-5.43.0.tar.xz
3ea0e4d347105399e7107c2ec644d19d kxmlgui-5.43.0.tar.xz
21de30d3ae86397ae92f94c7c160fb1e kbookmarks-5.43.0.tar.xz
43173ebb19608ca56e3b1a1c737b3716 kwallet-5.43.0.tar.xz
b8888829cf7064c756331c2e8347fd09 kio-5.43.0.tar.xz
235fdc815c6ba94e173cf66a07b1076f kdeclarative-5.43.0.tar.xz
7af955e653262eac715df202e8418d90 kcmutils-5.43.0.tar.xz
cb2fadba7600b65ecb8244959b5ba102 kirigami2-5.43.0.tar.xz
c47fc6ac7cd13b38cce0ba6675bdb967 knewstuff-5.43.0.tar.xz
e00d64384ffc2e28acd273b30e135a74 frameworkintegration-5.43.0.tar.xz
48f5100e0a11f24e9321fd2359408b1e kinit-5.43.0.tar.xz
8f69fc2f40676b75d1a6b64e3e0371bd knotifyconfig-5.43.0.tar.xz
3dbd8d893655c4d6682a3c2c44a59520 kparts-5.43.0.tar.xz
a443aaa90ddd41b11e4fa43b35a3f5dd kactivities-5.43.0.tar.xz
97cac58acb119a33a8c2a283daa82982 kded-5.43.0.tar.xz
c30a2a178179b024f5ebc188e9939b80 kdewebkit-5.43.0.tar.xz
995b7d7e3b5ec614870e6fc60f060a11 syntax-highlighting-5.43.0.tar.xz
3ea63f69a4ed61c57b0578bc12c25606 ktexteditor-5.43.0.tar.xz
5dd311e62bbebe45e5f816f8b18461b4 kdesignerplugin-5.43.0.tar.xz
b03e7c6c53b0919fc09059a1614b2aa2 kwayland-5.43.0.tar.xz
62454f341fbcadc0c25d1a18ef8e7014 plasma-framework-5.43.0.tar.xz
dfdfcb07d45d168a19c19cad86ca2cc7 modemmanager-qt-5.43.0.tar.xz
36b0d67bbe91455b9b4b1cbef0a31c14 kpeople-5.43.0.tar.xz
1c769bc468e07d91ae21ae7ddff7fd09 kxmlrpcclient-5.43.0.tar.xz
5fb2427ffd7214859f5e07fc265a7d53 bluez-qt-5.43.0.tar.xz
d3d04affad8ee9d001911e010e2ca7f2 kfilemetadata-5.43.0.tar.xz
ef7918c5ff090508ae79908706d1ca58 baloo-5.43.0.tar.xz
#e717dcb76e5dd8d7b7145d76db4f2b30 breeze-icons-5.43.0.tar.xz
#61ceb7583096c6ab70690a1e941dac8f oxygen-icons5-5.43.0.tar.xz
24de0d2d517279712e41533198d93ec6 kactivities-stats-5.43.0.tar.xz
d283025c9a8288d2a2fd52d0864323ed krunner-5.43.0.tar.xz
#73fe712d4c110cbd2c5117d3b7a8c213 prison-5.43.0.tar.xz
83b257a99b7f5144495c9ccd881ecd3b qqc2-desktop-style-5.43.0.tar.xz
7d81c30b200b0c70af66be9e63a9ad41 kjs-5.43.0.tar.xz
984f3900ca5fb33c57d5f0021b4e3fb8 kdelibs4support-5.43.0.tar.xz
9f2dcb4ed09d923c1f2727bb8b8cb5fa khtml-5.43.0.tar.xz
8dbb6955e804e71c0ee4ba1311107c5f kjsembed-5.43.0.tar.xz
55cc2b85fb8bdfe80b53e85d8d4f4610 kmediaplayer-5.43.0.tar.xz
94ad9a522521bbbb5a4de0c8a04946aa kross-5.43.0.tar.xz
9c5202b7ad2d6093df2b410866933b4c kholidays-5.43.0.tar.xz
2d05ea6fe77402fa059ba9e435e1c460 purpose-5.43.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5.old                         &&
install -v -dm755           /opt/kf5/{etc,share} &&
ln -sfv /etc/dbus-1         /opt/kf5/etc         &&
ln -sfv /usr/share/dbus-1   /opt/kf5/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


bash -e


export CXXFLAGS='-isystem /usr/include/openssl-1.0'
while read -r line; do
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    tar -xf $file
    pushd $packagedir
      mkdir build
      cd    build
      cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
            -DCMAKE_PREFIX_PATH=/opt/qt5        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make "-j`nproc`" || make
      as_root make install
    popd
  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
done < frameworks-5.43.0.md5
exit



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5-5.43.0
ln -sfvn kf5-5.43.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
