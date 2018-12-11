#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="kframeworks5"
DESCRIPTION="KDE Frameworks 5 is a collection of libraries based on top of Qt5 and QML derived from the monolithic KDE 4 libraries."
VERSION=5.46

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
#REQ:phonon
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt
#REC:bluez
#REC:ModemManager
#REC:oxygen-fonts
#REC:noto-fonts
#OPT:doxygen
#REC:jasper
#OPT:mitkrb
#REC:udisks2
#REC:upower
#REQ:qrencode
#OPT:qtwebengine


cd $SOURCE_DIR

whoami > /tmp/currentuser
commonBinDir="/var/cache/alps/binaries/"

url=http://kde.c3sl.ufpr.br/stable/frameworks/5.46/
wget -nc -r -nH --cut-dirs=3 -A '*.xz' -np $url
if [ -d portingAids ]; then
	mv portingAids/* .
fi

cat > frameworks-5.46.0.md5 << EOF
744dc9e456797eb65dc17708a4f6930f  attica-5.46.0.tar.xz
#f5a2ddb5160e16399f748313647d4916  extra-cmake-modules-5.46.0.tar.xz
b7c7dd61a1975fccbe2223f3d96dfa7e  kapidox-5.46.0.tar.xz
9a82e32ecaeecb65fa43393ab4f3a48f  karchive-5.46.0.tar.xz
7320c55f1394465d801a0f838e847bd1  kcodecs-5.46.0.tar.xz
eed27bdc7f37eb035bb78d3ed4b1bf09  kconfig-5.46.0.tar.xz
56b18e58fa143141f2a906aea58473cc  kcoreaddons-5.46.0.tar.xz
5d67200c6d00b7abbba5608e38eb3adc  kdbusaddons-5.46.0.tar.xz
76849742e7a0a8a755639b421f61269f  kdnssd-5.46.0.tar.xz
f031ccc85572a5bbecf7996be60b72a7  kguiaddons-5.46.0.tar.xz
563a1497e4be62b2f45289ebb05a1015  ki18n-5.46.0.tar.xz
39e01a23876ff8c3b7d7bf5476f51507  kidletime-5.46.0.tar.xz
99970c570cf6f68b62b7c2850fee91e3  kimageformats-5.46.0.tar.xz
d89c65ea022e193de5bec88e17622073  kitemmodels-5.46.0.tar.xz
15893a114ad2fe67cafa49aa4270ca44  kitemviews-5.46.0.tar.xz
dc8c9ba081a0c76af6a3bf24b3500fdf  kplotting-5.46.0.tar.xz
9401525c36516b6719ff3b902b539d00  kwidgetsaddons-5.46.0.tar.xz
481a95d42da42756b3071310cdca8413  kwindowsystem-5.46.0.tar.xz
512bc966f8522eea4660d4db424519eb  networkmanager-qt-5.46.0.tar.xz
a961e64883eb99d7ddd374d8e64f77ab  solid-5.46.0.tar.xz
477c6fc7cd97aed8a6a47a26cbc9807c  sonnet-5.46.0.tar.xz
f750df59bb52f74fceea9085fc0cd737  threadweaver-5.46.0.tar.xz
dd084a4c52e8e308fe2f17a5a6ffaab8  kauth-5.46.0.tar.xz
56559cc6ff7db07896625edcdc8a175a  kcompletion-5.46.0.tar.xz
60b2d68fbc8236e9595f2d7c2528dbe9  kcrash-5.46.0.tar.xz
7bf01d27a5b8ea92da09d4b1f0cb9be8  kdoctools-5.46.0.tar.xz
d5881c9502a3867f9ac2537c5c4d8139  kpty-5.46.0.tar.xz
c53b9c65b204135d7df8235b1e27126b  kunitconversion-5.46.0.tar.xz
cb263a59b6750f30dc219523873e9dd7  kconfigwidgets-5.46.0.tar.xz
da3837c37c31983e2f485cd858cbee1a  kservice-5.46.0.tar.xz
95eb20ed9270be73d545519483aa3aff  kglobalaccel-5.46.0.tar.xz
de6d426f6091c513986d5db4b37ea50b  kpackage-5.46.0.tar.xz
84fbce9781af3acaa7e0e94abfaa3405  kdesu-5.46.0.tar.xz
3ad0c95edfbedd383b535670876b2724  kemoticons-5.46.0.tar.xz
80750b3c4d479761448021c708515ad4  kiconthemes-5.46.0.tar.xz
736ee2bbe38de09f3a5dfbb125181f83  kjobwidgets-5.46.0.tar.xz
ead32ea5179d53a211251e05dfe0d6cf  knotifications-5.46.0.tar.xz
b95b19128aeef4a2e6b5a111ccb11b42  ktextwidgets-5.46.0.tar.xz
d8d9fc6b81317d553bc9ad1d49351e7b  kxmlgui-5.46.0.tar.xz
1c5c1ca0f47540e0306fe0b861f04cf7  kbookmarks-5.46.0.tar.xz
2e0d088d7ba5582d63035050bbad7f0b  kwallet-5.46.0.tar.xz
679181b29e12c7ea2c40613d4ceb1c04  kio-5.46.0.tar.xz
16214091286562cdd2dbcf3a00be599b  kdeclarative-5.46.0.tar.xz
5afc45d52f95a7ffba330412982a7164  kcmutils-5.46.0.tar.xz
dce9d8af74cddf8c56ae1d3c5bdd3d6f  kirigami2-5.46.0.tar.xz
b7dacfcf9de03166de6facf12ccd3290  knewstuff-5.46.0.tar.xz
6e28b6d861469f4f994149ab9126c464  frameworkintegration-5.46.0.tar.xz
af8348379145e77ce82731ff99d59332  kinit-5.46.0.tar.xz
643e1b77386aaf549b24e6a454f96a5f  knotifyconfig-5.46.0.tar.xz
04c8cd1ab1e59b11836b33b012297bdd  kparts-5.46.0.tar.xz
c5a455b91f0fce3fa9d05b5dd7b6e4ba  kactivities-5.46.0.tar.xz
7f34228533707b5c85f8ab2bae7b97a4  kded-5.46.0.tar.xz
#c0ee2de3ff585aefd74e16c766d183f3  kdewebkit-5.46.0.tar.xz
ab7de9568bec23ad56f11183570dee07  syntax-highlighting-5.46.0.tar.xz
82c8036688d81514b25dc83d535027c9  ktexteditor-5.46.0.tar.xz
6731356c0c86e9c706e58ce2cd621286  kdesignerplugin-5.46.0.tar.xz
1a5dab28ff9e07f13f528200cf3059d6  kwayland-5.46.0.tar.xz
f2ec2306159c76c3a9ed0d97c3e5c80f  plasma-framework-5.46.0.tar.xz
abf80b50c4717b01df213ef1db7a3e2a  modemmanager-qt-5.46.0.tar.xz
373d2ee51895074269fc1cd09641c8c3  kpeople-5.46.0.tar.xz
bb1058cbd1142e34e2b5dbbed790e507  kxmlrpcclient-5.46.0.tar.xz
2147a40a14d725bdf7538eb4f7a631e8  bluez-qt-5.46.0.tar.xz
5109a64c107385a71f7de575ebe0ce94  kfilemetadata-5.46.0.tar.xz
899dfc68daf13a71fb1146b57b1d26c9  baloo-5.46.0.tar.xz
#9db3c27c991006fef65b3a5ec82c2ba6  breeze-icons-5.46.0.tar.xz
#7c7a54154aa904d6a6ea9f3ce120376e  oxygen-icons5-5.46.0.tar.xz
58a50ac1aab2b36bcdcd6591ffd91d65  kactivities-stats-5.46.0.tar.xz
624ac26b1c64a06056535eaae7f1c73b  krunner-5.46.0.tar.xz
#9e76c7991e42b1f2edbd6e942c5519f0  prison-5.46.0.tar.xz
35b9cb4ec4fb46911da127a7403e7947  qqc2-desktop-style-5.46.0.tar.xz
a7c73a1b7563f8210a5dc26a3796a20f  kjs-5.46.0.tar.xz
c715aa25dd115088670ac89b4f41ceeb  kdelibs4support-5.46.0.tar.xz
545a88b8fc4099cdcddd012327c73c59  khtml-5.46.0.tar.xz
77febd8baf2bfb43cb02d61288887855  kjsembed-5.46.0.tar.xz
ad923a227080d356dd2af479e500c3a9  kmediaplayer-5.46.0.tar.xz
51f5582aed47ec1ab45fee3a427ee74f  kross-5.46.0.tar.xz
01648a0c6d839f71edef5020a8e114e8  kholidays-5.46.0.tar.xz
a28a44a1f985e757e911cd90ba2c0d32  purpose-5.46.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root

sudo tee -a /etc/profile.d/qt5.sh << "EOF"
# Begin kf5 extension for /etc/profile.d/qt5.sh

pathappend /usr/lib/qt5/plugins    QT_PLUGIN_PATH
pathappend $QT5DIR/lib/plugins     QT_PLUGIN_PATH
pathappend /usr/lib/qt5/qml        QML2_IMPORT_PATH
pathappend $QT5DIR/lib/qml         QML2_IMPORT_PATH

# End extension for /etc/profile.d/qt5.sh
EOF

sudo tee /etc/profile.d/kf5.sh << EOF
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/usr

# End /etc/profile.d/kf5.sh
EOF

touch /tmp/completed

export KF5_PREFIX=/usr
export QT5DIR=/usr
pathappend /usr/lib/qt5/plugins    QT_PLUGIN_PATH
pathappend $QT5DIR/lib/plugins     QT_PLUGIN_PATH
pathappend /usr/lib/qt5/qml        QML2_IMPORT_PATH
pathappend $QT5DIR/lib/qml         QML2_IMPORT_PATH

while read -r line; do
    if ! grep "$line" /tmp/completed
    then
      # Get the file name, ignoring comments and blank lines
      if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
      file=$(echo $line | cut -d" " -f2)
      pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
      packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
      tar -xf $file
      pushd $packagedir
        mkdir -pv build
        cd    build
        cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
              -DCMAKE_PREFIX_PATH=$QT5DIR        \
              -DCMAKE_BUILD_TYPE=Release         \
              -DLIB_INSTALL_DIR=lib              \
              -DBUILD_TESTING=OFF                \
              -Wno-dev ..
        make "-j`nproc`"
        as_root make install
    popd
    as_root rm -rf $packagedir
    as_root /sbin/ldconfig
    echo $line >> /tmp/completed
  fi
done < frameworks-5.46.0.md5

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

