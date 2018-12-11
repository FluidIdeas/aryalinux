#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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
#REQ:perl-uri
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
#OPT:Jinja2
#OPT:PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower

cd $SOURCE_DIR


NAME=krameworks5
VERSION=""
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

url=http://download.kde.org/stable/frameworks/5.49/
wget -r -nH -nd -A '*.xz' -np $url
cat > frameworks-5.49.0.md5 << "EOF"
<code class="literal">1b9a8d7fa78f14df0395d6533e07c233 attica-5.49.0.tar.xz #44d277d5df5aa806f8caf4b12541b15c extra-cmake-modules-5.49.0.tar.xz 4b369263ce39d96093c64318bd69ac60 kapidox-5.49.0.tar.xz 541071a7a336ca167d66b6bee5bb98a0 karchive-5.49.0.tar.xz 3189f9540de1bcf93edeef7fc8fdb853 kcodecs-5.49.0.tar.xz 57f6c446d29483fb2cfb285eb956a91b kconfig-5.49.0.tar.xz 2e5cd09584c276416d56f66b8b3ee97b kcoreaddons-5.49.0.tar.xz a496b86727152d8b59ed2a2228003ac2 kdbusaddons-5.49.0.tar.xz 19c1372fb1a702f57c66cf5803049d50 kdnssd-5.49.0.tar.xz 4a733f7fb98fb936d74a688fe9959dd7 kguiaddons-5.49.0.tar.xz a04e3c5b5c23c273fbdbdb3dea8fc0a1 ki18n-5.49.0.tar.xz c54edfca13c0e8dac161048db33b4bce kidletime-5.49.0.tar.xz 589ed57faba25f2014964619247aa28a kimageformats-5.49.0.tar.xz 4412ab5a5446aab1df6f7bb59bac4365 kitemmodels-5.49.0.tar.xz 72d840e8ce2324a8e01cd3f2a3c269b2 kitemviews-5.49.0.tar.xz df18871fbc9494d6318d7106f5924c53 kplotting-5.49.0.tar.xz 3c6aa861640fd55a34e359ef798a916d kwidgetsaddons-5.49.0.tar.xz 4db7723226f6b0e0d8705d3fe53642a3 kwindowsystem-5.49.0.tar.xz a4202fa94b64d65db2e4b7be34675c95 networkmanager-qt-5.49.0.tar.xz 391b3473e9e5d31d6e301f27e657ae4f solid-5.49.0.tar.xz f3e739976224f0b14ae653534e503df4 sonnet-5.49.0.tar.xz c068e97cfc0a42f0d32ca927a12691fe threadweaver-5.49.0.tar.xz ed2183a6db12ce48f96b844287e53925 kauth-5.49.0.tar.xz 6790087dd73139a6e21e3cdf663271e5 kcompletion-5.49.0.tar.xz c8c73f76432306b98ef038418c62ce44 kcrash-5.49.0.tar.xz 9376c84a3f70b95ae0141d90e1aaf165 kdoctools-5.49.0.tar.xz 9e690e1d76196c092b34605336e16ccb kpty-5.49.0.tar.xz 9424c658138501742a2af85495c47f60 kunitconversion-5.49.0.tar.xz 82d5d219494a2ad1514157a7064521d0 kconfigwidgets-5.49.0.tar.xz 26524fb8e33b8ab3aebf86ec078c7518 kservice-5.49.0.tar.xz 712658831c71f5127762ffa0016a7a39 kglobalaccel-5.49.0.tar.xz 232e476d2d59b789a10c7be3cb6832a0 kpackage-5.49.0.tar.xz 57a2a02a7061040a6a437a1df6dacbd8 kdesu-5.49.0.tar.xz f98c6e3ab806c0f76ab76f0291e4dd93 kemoticons-5.49.0.tar.xz bad840d753b545cc1d166c773d1c284c kiconthemes-5.49.0.tar.xz f26fc58203dcad45d3c20545c5a48e53 kjobwidgets-5.49.0.tar.xz 2d276031a63a7bc76258991472056f5a knotifications-5.49.0.tar.xz 012e92d2f2ce4574d2d3d0dbddc748af ktextwidgets-5.49.0.tar.xz 009205833a4135eee008b6ea55833bb2 kxmlgui-5.49.0.tar.xz eb0c686f3c61cd74c1740a030bdc4206 kbookmarks-5.49.0.tar.xz 802c5985ccfff94cfa025d6a938e7476 kwallet-5.49.0.tar.xz 826fc93fd2f0c337f7ef6bb8c10c0b22 kio-5.49.0.tar.xz 5febec6dc30c02caac9c46fc48d8a92a kdeclarative-5.49.0.tar.xz b15758b0500e97866ea4b32dd042ae39 kcmutils-5.49.0.tar.xz 9431414418dbf8f906f4e13f33479256 kirigami2-5.49.0.tar.xz d6771e1a02516c7bfb24ece46019abc4 knewstuff-5.49.0.tar.xz 175a23040d853e1710f525b42e22c6f5 frameworkintegration-5.49.0.tar.xz f6b5fada29fde1223aa976476f583427 kinit-5.49.0.tar.xz 53fe83e865aa5ef5b50dbfc58037a80f knotifyconfig-5.49.0.tar.xz f045b11f61eb244a9636e87eef84c496 kparts-5.49.0.tar.xz 9ed8874d043d2faafa28bf5ed2e3ea2a kactivities-5.49.0.tar.xz d47cdb541b3f4a3823dd420db170964d kded-5.49.0.tar.xz #014cde3b2f046494845bd88c8abc5883 kdewebkit-5.49.0.tar.xz 4b9837a0c1bc5bdb9acd146e0004759b syntax-highlighting-5.49.0.tar.xz 3fdec786eb549cdb398c9da23e1eb94e ktexteditor-5.49.0.tar.xz 6b4322afedde3304387c459d133c5d1e kdesignerplugin-5.49.0.tar.xz 5d4800ad4363d836c26b374c97d8be58 kwayland-5.49.0.tar.xz 913a57607b9c57daef88c90356f55986 plasma-framework-5.49.0.tar.xz 3a18f1b5eb357a16a786b30f12b16028 modemmanager-qt-5.49.0.tar.xz ede339e08f7432f94ab85093241e104c kpeople-5.49.0.tar.xz 36d5ea545b972d275b4fde563202fed3 kxmlrpcclient-5.49.0.tar.xz e311eee50522f739951b0fec7add2374 bluez-qt-5.49.0.tar.xz ed176f7718b4f95688b7d4d109708d13 kfilemetadata-5.49.0.tar.xz bbe82a79319abba8171769bb83b06d88 baloo-5.49.0.tar.xz #aa29fe929300b41c44be52b9ee8a9e9c breeze-icons-5.49.0.tar.xz #48136fe0337c9e3a7f57324b9b943d59 oxygen-icons5-5.49.0.tar.xz 037b33038aa30fb78cc05e4e7961b983 kactivities-stats-5.49.0.tar.xz 12b562c1509281001c6b32a5842e453b krunner-5.49.0.tar.xz #dfc717b8fe63f3167d8bfea6f97b1ae6 prison-5.49.0.tar.xz a84a244620b0febcb4a4527b0d7a6d09 qqc2-desktop-style-5.49.0.tar.xz 01ba726dc3fc0c440f9adacf66cb5681 kjs-5.49.0.tar.xz 22f9b04aebae7ddbf3fe5d3bfd93e541 kdelibs4support-5.49.0.tar.xz b854adbf8ef148a426f079055e16b182 khtml-5.49.0.tar.xz 7025261ab8657c34b8110fd1419a6bc4 kjsembed-5.49.0.tar.xz b9e38efe9fd70d30ff2275177ec8f95a kmediaplayer-5.49.0.tar.xz 7297399799ef96f2a29b9e35c0dc57a7 kross-5.49.0.tar.xz ba7bac91aeeddb03631dd12b6d44f9e2 kholidays-5.49.0.tar.xz 17fd75131e1860a2b77021770de8d40c purpose-5.49.0.tar.xz</code>
EOF
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mv -v /opt/kf5 /opt/kf5.old                         &&
install -v -dm755           $KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1         $KF5_PREFIX/etc         &&
ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

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

      cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
            -DCMAKE_PREFIX_PATH=$QT5DIR        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make
      as_root make install
    popd

  as_root rm -rf $packagedir
  as_root /sbin/ldconfig

done < frameworks-5.49.0.md5

exit

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mv -v /opt/kf5 /opt/kf5-5.49.0
ln -sfvn kf5-5.49.0 /opt/kf5
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
