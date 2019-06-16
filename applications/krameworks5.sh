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
#REQ:perl-modules#perl-uri
#REQ:wget
#REQ:aspell
#REQ:avahi
#REQ:libdbusmenu-qt
#REQ:networkmanager
#REQ:polkit-qt
#REQ:kf5-intro
#REQ:noto-fonts
#REQ:oxygen-fonts
#REQ:bluez
#REQ:modemmanager
#REQ:jasper
#REQ:mitkrb
#REQ:udisks2
#REQ:upower
#REQ:media-player-info


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.58


NAME=krameworks5
VERSION=5.58
URL=http://download.kde.org/stable/frameworks/5.58

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


url=http://download.kde.org/stable/frameworks/5.58/
wget -r -nH -nd -A '*.xz' -np $url
cat > frameworks-5.58.0.md5 << "EOF"
f1b0eba58f4e29c6c9af2a39a4d92052  attica-5.58.0.tar.xz
#ab2e42031a1aa96eca27d029827fe9d8  extra-cmake-modules-5.58.0.tar.xz
45ca6b083bf51ed1cebaf11431c20f71  kapidox-5.58.0.tar.xz
8d386da9f2e3a64018b979a8a0512a18  karchive-5.58.0.tar.xz
5e2fd0f6588523b30ab9c8ab53bb1d76  kcodecs-5.58.0.tar.xz
f0a5d4f90ff74a764691e1d31caa378c  kconfig-5.58.0.tar.xz
ea7e5f1f3f880e1814e9952998476f76  kcoreaddons-5.58.0.tar.xz
2c0b68f305c296ab785c65d356ae0f45  kdbusaddons-5.58.0.tar.xz
c373138c303866478fb848774bba0ce0  kdnssd-5.58.0.tar.xz
4485550ff755fd84f3126a2079dda66b  kguiaddons-5.58.0.tar.xz
82e0f37a01ad489db993833470ea59a8  ki18n-5.58.0.tar.xz
f9189c3ba90584800c51686167a310d5  kidletime-5.58.0.tar.xz
77c013f9a37934fc20239d0a3da205ba  kimageformats-5.58.0.tar.xz
7d1a541f0e3ecb0e31a1e02bf14ec043  kitemmodels-5.58.0.tar.xz
aa0444b0e1d59198eb5909931dacc8d7  kitemviews-5.58.0.tar.xz
d714d9cbcb2a5083f283c5831f9d9969  kplotting-5.58.0.tar.xz
05f0c66e03250369f296dfedf99ae9b4  kwidgetsaddons-5.58.0.tar.xz
596760bde216cb7335193fec16baeec4  kwindowsystem-5.58.0.tar.xz
95bc9df762d4a99b6e71f3fae9ee2bad  networkmanager-qt-5.58.0.tar.xz
f6a9c58ce4e5a6ff82dd11f431aa3610  solid-5.58.0.tar.xz
1bb0c7eaaa57e91364da4ff023eaa7fd  sonnet-5.58.0.tar.xz
39c96c38a87fee145d43d894cfbff64f  threadweaver-5.58.0.tar.xz
a5df25b21f6aab84e310cd1d4f201141  kauth-5.58.0.tar.xz
920cf624a739e63290743f5c3fa418f1  kcompletion-5.58.0.tar.xz
c526a1714cf265711e0a20e9888978eb  kcrash-5.58.0.tar.xz
0fb5dd4eb907b55782e321f3d86eb825  kdoctools-5.58.0.tar.xz
fb18265b0c83adbb4af57b7c0588ff31  kpty-5.58.0.tar.xz
dc840b7be1e9c8e4ba715b3fee264714  kunitconversion-5.58.0.tar.xz
1c3ef53c26083ccd886144d794f56b3f  kconfigwidgets-5.58.0.tar.xz
748c4fe209139249efaa669edb07fc91  kservice-5.58.0.tar.xz
36c37994da9057dbda764229c847e873  kglobalaccel-5.58.0.tar.xz
cddda5df856b84d82289056e2521e0f5  kpackage-5.58.0.tar.xz
4e927df18363fc6f7da0154e9d097f31  kdesu-5.58.0.tar.xz
b5ccd7868f3b506c238c3492a56ba65a  kemoticons-5.58.0.tar.xz
2111f28ff4051914be2b7caf355befb4  kiconthemes-5.58.0.tar.xz
ba814954d8506f44f3f683a427f4628c  kjobwidgets-5.58.0.tar.xz
4865198f8406068c67254ee3b59faab4  knotifications-5.58.0.tar.xz
1d030a5e1a52bac6528d39737d52ffb8  ktextwidgets-5.58.0.tar.xz
899f9dca54c336c0034fa0aee2b5bf8f  kxmlgui-5.58.0.tar.xz
979b5612fd76e0959736347b4dbccce7  kbookmarks-5.58.0.tar.xz
b27baeea7c21967609a4507cf616d47a  kwallet-5.58.0.tar.xz
1c8b5a0d4eddab6a97f387c5e5fd67a2  kio-5.58.0.tar.xz
c431a6562b643dcb1d56f3170d05025d  kdeclarative-5.58.0.tar.xz
cb3326fe23c757af9588f97f44882d71  kcmutils-5.58.0.tar.xz
ba2f49c4a857c4fc603d6e7930a4e665  kirigami2-5.58.0.tar.xz
c34bd0c3876e657c2dd92265a88071b3  knewstuff-5.58.0.tar.xz
4b8bd790e04ff1e7998fc96f4e505760  frameworkintegration-5.58.0.tar.xz
4d914c5ae3010ae600c858e9ccdeecb2  kinit-5.58.0.tar.xz
e5917ac42030612bfc952e3967072469  knotifyconfig-5.58.0.tar.xz
79b028e61cbab0cfeb167e02363fad44  kparts-5.58.0.tar.xz
e38977ae6c504a4f092c1c6ad3b6d28a  kactivities-5.58.0.tar.xz
4cb98a0531c0c9aea801f7678400c280  kded-5.58.0.tar.xz
#88b0b5fd5e7debdf6291263f1e4a9478  kdewebkit-5.58.0.tar.xz
a93c3854a98a7616f02676cd2d6f1ed3  syntax-highlighting-5.58.0.tar.xz
9b26b1c6de1b19e8995f66fd31ab9901  ktexteditor-5.58.0.tar.xz
2b96b2eab04f75ec34b2017ca95d5a16  kdesignerplugin-5.58.0.tar.xz
1f029fbeb30e11fa362fa9a5ef836111  kwayland-5.58.0.tar.xz
fc77bd0e0e3d0905be7b32cb7ae0f9eb  plasma-framework-5.58.0.tar.xz
#d1822d13276bde0be4dae6749a3b61b5  modemmanager-qt-5.58.0.tar.xz
d379b213cf068b4a73503c3922ca20b5  kpeople-5.58.0.tar.xz
4ca1ac3fd1d98a08baf8f70536c6a27a  kxmlrpcclient-5.58.0.tar.xz
13ba6a2b5051d0d03b0d0a6e056ec1a5  bluez-qt-5.58.0.tar.xz
5bd7d7b91b0c1e70a0c49bedc8eac381  kfilemetadata-5.58.0.tar.xz
cf5ba6707cd5ee804bc6ee57b712bd84  baloo-5.58.0.tar.xz
#551a7d46848ec758464a1cc96c68672f  breeze-icons-5.58.0.tar.xz
#4d2016bc53b675a776b7321e49132dee  oxygen-icons5-5.58.0.tar.xz
8e1d8fdda1588b98fe0fc8dcda08d217  kactivities-stats-5.58.0.tar.xz
f61cded81c889d8c92dde7c9234858e5  krunner-5.58.0.tar.xz
#7c2a5f7808304f3d8404a8083bf54e8f  prison-5.58.0.tar.xz
789d6b25e609a51e5fc86f397ccff7d2  qqc2-desktop-style-5.58.0.tar.xz
7c88ae56084c5b43538344af72b4b6d2  kjs-5.58.0.tar.xz
1c4d788d910c3d7c06734aed2524ad0d  kdelibs4support-5.58.0.tar.xz
d62ea2b2a7eecd46f3b95460b8a94956  khtml-5.58.0.tar.xz
d9cac6962c2820ab99661ba6e2d0d799  kjsembed-5.58.0.tar.xz
a117c2e069988d910ee5478346c6ca0f  kmediaplayer-5.58.0.tar.xz
5e09b84e2675fe3c545d41ae347877c2  kross-5.58.0.tar.xz
d3f3e84e2658cd46489b591d79d85226  kholidays-5.58.0.tar.xz
5fe559e1dc6f42b8b207f34b4aa8f340  purpose-5.58.0.tar.xz
3f83b4120f4de8021056d878bba60c9a  syndication-5.58.0.tar.xz
EOF
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    name=$(echo $pkg|sed 's|-5.*$||') # Isolate package name

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

done < frameworks-5.58.0.md5

exit


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

