#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

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



NAME=krameworks5
VERSION=5.67

SECTION="KDE Plasma 5"

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


url=http://download.kde.org/stable/frameworks/5.67/
cat > frameworks-5.67.0.md5 << "EOF"
d3b975029a5b53673ea6503a2d5ae177  attica-5.67.0.tar.xz
#f59f70433adc17145b6ce2e8ab0c416d  extra-cmake-modules-5.67.0.tar.xz
d2b51d5f9a5e31ca870df0c48e4960e9  kapidox-5.67.0.tar.xz
ca01da6d4bedb8fbe9b99600f8f45ed2  karchive-5.67.0.tar.xz
080f45c31980d514774161d1b4a30ff8  kcodecs-5.67.0.tar.xz
3a40f76617827bff8e0c99b93be01fc1  kconfig-5.67.0.tar.xz
5c35270ed01148af9038e62350e51e32  kcoreaddons-5.67.0.tar.xz
818dbca1b3536e931aed3f6a4fb9d955  kdbusaddons-5.67.0.tar.xz
11c8c768748b562b928754d596b0aec6  kdnssd-5.67.0.tar.xz
96b919dfe2aedb0a5747b64216c95fff  kguiaddons-5.67.0.tar.xz
e6a5226f42a3cc444938fb80a7463ab4  ki18n-5.67.0.tar.xz
8049864248f5ab73af529140a10b0386  kidletime-5.67.0.tar.xz
3d17d70e54a82063c032ee9efee45874  kimageformats-5.67.0.tar.xz
588eba3b0ff5768e5aeda6dd0dcdfc29  kitemmodels-5.67.0.tar.xz
76990691b3c57e9c02c5da55144764a4  kitemviews-5.67.0.tar.xz
3242e4364f2f21980f208c1685019fd0  kplotting-5.67.0.tar.xz
9616a12c63a1c65562e7f5b5fcb29e07  kwidgetsaddons-5.67.0.tar.xz
b1d0b95573ff7cfe1ff4d468e7f9fed6  kwindowsystem-5.67.0.tar.xz
00b66a3798bf1abb074b4147ee0e5b7c  networkmanager-qt-5.67.0.tar.xz
0598657737a55b535d4bb0dbb9bba889  solid-5.67.0.tar.xz
37f09137396721abad617571464b9d9a  sonnet-5.67.0.tar.xz
8ee447185a4e603cc409ee4218cee195  threadweaver-5.67.0.tar.xz
8677547f35f4d4720d41325fbd3a6336  kauth-5.67.0.tar.xz
eb09a60dd4b5753e2aeaa8087efa4bb4  kcompletion-5.67.0.tar.xz
bfaeba1fad5c8440e37f145b011cf03e  kcrash-5.67.0.tar.xz
6f9879d824b265096b8384ab5061ccca  kdoctools-5.67.0.tar.xz
4add397011f28a5a08c363f0a5d2ad60  kpty-5.67.0.tar.xz
dc0bf58b6239d93e8d65b6a635256fd1  kunitconversion-5.67.0.tar.xz
f00cf13031ae84283c16b56c400a51f7  kconfigwidgets-5.67.0.tar.xz
290466bdeddfc2c04c5a872a773d974d  kservice-5.67.0.tar.xz
b688a1639bc9497fb3787f9d93950bda  kglobalaccel-5.67.0.tar.xz
6bf9110d2c3746fdf0c70cc8451c3596  kpackage-5.67.0.tar.xz
a4d9df054c4f7d4672be9f12596d877e  kdesu-5.67.0.tar.xz
6a806ed9f1854c24dcaf653c7f91511e  kemoticons-5.67.0.tar.xz
fd90eda4d83598fefb87db83463cca1f  kiconthemes-5.67.0.tar.xz
3a8533dcb22764c9f80eb9957d530170  kjobwidgets-5.67.0.tar.xz
37d8e17a44cca54f8e937bd1b80231d3  knotifications-5.67.0.tar.xz
fe7fefbc23ca7eef85f95cbc54f193b3  ktextwidgets-5.67.0.tar.xz
4565a3d1f277653e41310a3ae26dcc1e  kxmlgui-5.67.0.tar.xz
1236b6fd559c9ac85e5c7d82fe5bbb02  kbookmarks-5.67.0.tar.xz
895e560a0b748dbb007ff45ec71ce85d  kwallet-5.67.0.tar.xz
b3cd883d9892f47dfbb7b2c29be0ff1b  kio-5.67.0.tar.xz
5f491d1b51cbafefff0d502c2818a1c9  kdeclarative-5.67.0.tar.xz
3fd40a72390912440c06289b5a17faa8  kcmutils-5.67.0.tar.xz
f9077200aa86833705a7f4250d61c0e6  kirigami2-5.67.0.tar.xz
0033e888f61c2f257e6e6f4a2011a976  knewstuff-5.67.0.tar.xz
6dc5c1e55e8ca4cc19e6faa8719b9cc4  frameworkintegration-5.67.0.tar.xz
646771a2d35f1af7c5d0f4cfb3f80179  kinit-5.67.0.tar.xz
6e43a6a6cf0a60eb8f31269834795fc4  knotifyconfig-5.67.0.tar.xz
cc3125f7ae87b52e62571040749a4732  kparts-5.67.0.tar.xz
37a1c1995cd80c8c5d53de70f9fe61ed  kactivities-5.67.0.tar.xz
5857f91c556d03fa6178ddc7d2d6a3dd  kded-5.67.0.tar.xz
#a447900424cd04dbaf49e8bf9617f6dc  kdewebkit-5.67.0.tar.xz
91319edc9d27393df6812d60f1505b99  syntax-highlighting-5.67.0.tar.xz
de9f38ec3ad76a5f19b4fc665dee5b82  ktexteditor-5.67.0.tar.xz
923482f22930286d7f99af334c3a2181  portingAids/kdesignerplugin-5.67.0.tar.xz
5141cdc1fcd46d43ac0043c10112be2b  kwayland-5.67.0.tar.xz
5203954a541766bd0def96fe2ddc1d05  plasma-framework-5.67.0.tar.xz
#f7b27e1fb53fbf7ccc3fabb3469b2ac3  modemmanager-qt-5.67.0.tar.xz
aa74dc95497e27a322668df02c21ba6f  kpeople-5.67.0.tar.xz
604ee822d3c31c025ea90a64692db277  kxmlrpcclient-5.67.0.tar.xz
4bf38a4919ea975deb71197c57a8edf0  bluez-qt-5.67.0.tar.xz
6fa27bb4fb5e3a08bc58b6d67e4ca396  kfilemetadata-5.67.0.tar.xz
05d339861c1b9082dc7b8f4822167954  baloo-5.67.0.tar.xz
#18d27b2f7d443a6e7e4fdc41a3fb9ae4  breeze-icons-5.67.0.tar.xz
#4d74544c61cb1db49a6b10da6835ec88  oxygen-icons5-5.67.0.tar.xz
b89c11f239048e4d65b4781fbc660a41  kactivities-stats-5.67.0.tar.xz
9da490e8e8ccfed43206d18a176019f8  krunner-5.67.0.tar.xz
#181d901dbda09ee7d26fd234eef56ed4  prison-5.67.0.tar.xz
46b9c80d3ef84a26803d47fc57426158  qqc2-desktop-style-5.67.0.tar.xz
b8352b2a459df37ac5fc8b5be5674d08  portingAids/kjs-5.67.0.tar.xz
aa5d6287fdae772c72ac15bb56315e53  portingAids/kdelibs4support-5.67.0.tar.xz
8c4ec0e9a3ac90622c64ecc0e3329d91  portingAids/khtml-5.67.0.tar.xz
10163d7d799db8cc90afcb7f2acb89d8  portingAids/kjsembed-5.67.0.tar.xz
88c78b268916199328c381de5d65020b  portingAids/kmediaplayer-5.67.0.tar.xz
46ded68727de15c4d66ce29b4bb15831  portingAids/kross-5.67.0.tar.xz
3d1831377c10ca2f90a5edd133501f84  kholidays-5.67.0.tar.xz
4039367834bc9039a84261b5a8d9912c  purpose-5.67.0.tar.xz
59240be3b390227198e8d94f5ae87fe8  syndication-5.67.0.tar.xz
91aadb3a165ac2ec1f5ab01f523bdeed  kcalendarcore-5.67.0.tar.xz
a8f99a97898c0489577204f219c7a5a3  kcontacts-5.67.0.tar.xz
b07cef12653a85091fadd25260942cf6  kquickcharts-5.67.0.tar.xz
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
    touch /tmp/kframeworks-done
    if grep $file /tmp/kframeworks-done; then continue; fi
    wget -nc $url/$file
    if echo $file | grep /; then file=$(echo $file | cut -d/ -f2); fi

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    name=$(echo $pkg|sed 's|-5.*$||') # Isolate package name

    tar -xf $file
    pushd $packagedir

      case $name in
        kitemviews*) sed -i '/<QList>/a #include <QPersistentModelIndex>' \
          src/kwidgetitemdelegatepool_p.h ;;
        kplotting*) sed -i '/<QHash>/a #include <QHelpEvent>' \
          src/kplotwidget.cpp ;;
        knotifica*) sed -i '/<QUrl>/a #include <QVariant>' \
          src/knotification.h ;;
        kcompleti*) sed -i '/<QClipboard>/a #include <QKeyEvent>' \
          src/klineedit.cpp ;;
        kwayland*) sed -i '/<wayland-xdg-output-server-proto/a #include <QHash>' \
          src/server/xdgoutput_interface.cpp ;;
      esac  

      mkdir build
      cd    build

      cmake -DCMAKE_INSTALL_PREFIX=/usr \
            -DCMAKE_PREFIX_PATH=$QT5DIR        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make
      as_root make install
    popd

  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
echo $file >> /tmp/kframeworks-done

done < frameworks-5.67.0.md5



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

