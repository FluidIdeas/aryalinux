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
VERSION=5.64


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


url=http://download.kde.org/stable/frameworks/5.64/
wget -r -nH -nd -np -A '*.xz' $url
cat > frameworks-5.64.0.md5 << "EOF"
04201c36ee67fc57179f4a646ca520e3  attica-5.64.0.tar.xz
#ca705855a8d06ae606e0d646dbf327b0  extra-cmake-modules-5.64.0.tar.xz
d2e7484e70045efce2ae03cbdb83e0ce  kapidox-5.64.0.tar.xz
8f245b3ffc777368f7394cd06bb60b26  karchive-5.64.0.tar.xz
cbc2f74150a910dc64f48a86cc2cf934  kcodecs-5.64.0.tar.xz
b16792f6cee787209ba678081fd9cc1c  kconfig-5.64.0.tar.xz
df043d47f24b6c983ed940cbe1af132b  kcoreaddons-5.64.0.tar.xz
d7de1a2c0cd9c3308aee5c932573a3da  kdbusaddons-5.64.0.tar.xz
974d79b965ebbee019f81b68e062aaec  kdnssd-5.64.0.tar.xz
7dc0b622ddf3ed90c7c8135e29950080  kguiaddons-5.64.0.tar.xz
374b0b8e7f4660f1e9159cc202e4d07e  ki18n-5.64.0.tar.xz
7e47e4020a5bd7728d81f24b9eaaa2a9  kidletime-5.64.0.tar.xz
9bedf2a73e4659ace5efd8415b8a10ea  kimageformats-5.64.0.tar.xz
9f8ec9983c19c52b3bbce8e308725e7d  kitemmodels-5.64.0.tar.xz
be56db58cd6537fe3a138f2b04fdf5c7  kitemviews-5.64.0.tar.xz
3f405d8c3511d4049f5a93ea66dd0cc8  kplotting-5.64.0.tar.xz
e3b457924fcaecb0073216c0899b1167  kwidgetsaddons-5.64.0.tar.xz
1c3e335bf029d0da1f4f6b4f9342ae84  kwindowsystem-5.64.0.tar.xz
44914f08bec33cc49ffeb886b13f6614  networkmanager-qt-5.64.0.tar.xz
2d17cc9129b3bad594c0dd09e663caa9  solid-5.64.0.tar.xz
cf7eedbf3fd395823e1cc90ce7321dcb  sonnet-5.64.0.tar.xz
6f969f0a793d5a25c0bd09d3ad466fd9  threadweaver-5.64.0.tar.xz
a94fc1e5fb09982808a3525f86492738  kauth-5.64.0.tar.xz
53889e7526d0a4e389523545bccf1d88  kcompletion-5.64.0.tar.xz
1110b19b78f7260d8b9a1aed4db21f09  kcrash-5.64.0.tar.xz
c5016655913132cc5a30896b77aeeb73  kdoctools-5.64.0.tar.xz
ac6bc187ab30a768777e00fe1eaa92bd  kpty-5.64.0.tar.xz
56b729998529c57f6dc6f8d4f1423fa9  kunitconversion-5.64.0.tar.xz
03518a7021c0af253ece25728f9ac25a  kconfigwidgets-5.64.0.tar.xz
2a3d3efa102078fafca0d34180137289  kservice-5.64.0.tar.xz
2e672c2bc14716b988e224b81772b569  kglobalaccel-5.64.0.tar.xz
02ac3300212b7426487e583ff0fec836  kpackage-5.64.0.tar.xz
5202294263f7b68c775b597095b2ccc4  kdesu-5.64.0.tar.xz
059f219e4b425bd18fbc0f5236eea29b  kemoticons-5.64.0.tar.xz
a72399f496b3813277e69477a56b98e8  kiconthemes-5.64.0.tar.xz
a5cc3b4abb1b7986f99d3977c00afd16  kjobwidgets-5.64.0.tar.xz
a78af6ba485f56bbbbf222e6b61aedb8  knotifications-5.64.0.tar.xz
914b35abd57934eec7abb8287d6f540a  ktextwidgets-5.64.0.tar.xz
ec74e7698e3f0f34facc0a189373b977  kxmlgui-5.64.0.tar.xz
3f8fc9273ab02e29b747ccd993f6f82d  kbookmarks-5.64.0.tar.xz
053848f2f12241de152c6b38623eb3c4  kwallet-5.64.0.tar.xz
bae95a766a2cec6dd7c9fa8f89aca9d2  kio-5.64.0.tar.xz
ab5a0303bcd8db7e4e9fb212103370fd  kdeclarative-5.64.0.tar.xz
8c408da1f427b049b742821b72f4bee5  kcmutils-5.64.0.tar.xz
de169a608b5af73f8253c6efd1fa07f1  kirigami2-5.64.0.tar.xz
5dce1312633d8e350280dbbdeea79772  knewstuff-5.64.0.tar.xz
20b263e99dd12f82e5cacdf0a8d5699e  frameworkintegration-5.64.0.tar.xz
f88eeb2e12a9ad23434e29046fe4fbc6  kinit-5.64.0.tar.xz
a17509998a3b61b1fd0732b45ad34389  knotifyconfig-5.64.0.tar.xz
d6f776cfe357c4f4387cc7df1e8dc82a  kparts-5.64.0.tar.xz
cad4b226ed9da8182db5c97d1cdbe45f  kactivities-5.64.0.tar.xz
6c59a0edae857dd261d724838193995d  kded-5.64.0.tar.xz
#1b009daa18a4d5dcea44a06a3cf565e3  kdewebkit-5.64.0.tar.xz
4266efccbf1500c4375b270e013060fd  syntax-highlighting-5.64.0.tar.xz
4b23b94d0f38d293b5c043bed8455451  ktexteditor-5.64.0.tar.xz
adbc56e452dca4a6c00ca70157d7d21d  kdesignerplugin-5.64.0.tar.xz
a6015cc5f0ebc88926e5de857c53572f  kwayland-5.64.0.tar.xz
da6a56cec4cda081a2f7b96a00adb02c  plasma-framework-5.64.0.tar.xz
#87e9399e34c1dafaf644d0a582016007  modemmanager-qt-5.64.0.tar.xz
c7329c21975ebe1d51e7d586adb931c8  kpeople-5.64.0.tar.xz
49dce029316e248018f7f63476a48203  kxmlrpcclient-5.64.0.tar.xz
30eb0e3a1eee677126ef34e888cf8aca  bluez-qt-5.64.0.tar.xz
b1e29c0c619b1018be697e899ff38dbf  kfilemetadata-5.64.0.tar.xz
a799d7e2b91840e34283725daba08f0c  baloo-5.64.0.tar.xz
#ecba20d51471d9cf6a76085d9f286905  breeze-icons-5.64.0.tar.xz
#2f6b2f619a737db9daf254b8bc91bb62  oxygen-icons5-5.64.0.tar.xz
39b04723e83a630dc845d0116d3ff127  kactivities-stats-5.64.0.tar.xz
329ea65e41c5d6e42fa69df0248404bf  krunner-5.64.0.tar.xz
#7c372e723a3cb713cbad3c0880157a0b  prison-5.64.0.tar.xz
a59fe759407bbf748f512e3e54236ac6  qqc2-desktop-style-5.64.0.tar.xz
616235430c5a93e70b235b3034e93650  kjs-5.64.0.tar.xz
bdad864bae23a0ec63ba0d89b4c186bf  kdelibs4support-5.64.0.tar.xz
3346439fb5d89c8cf73b606bdbd586a5  khtml-5.64.0.tar.xz
c6a3bcfb93bacdd2f042d731c8a3532d  kjsembed-5.64.0.tar.xz
4428adcff009b4b28fc75bfe8d17b2c5  kmediaplayer-5.64.0.tar.xz
75d4e6f1e5cc0d84ec6e89f9bda698c7  kross-5.64.0.tar.xz
8945bfcb4aa7d17cee36e7a5cfb9d5b8  kholidays-5.64.0.tar.xz
171824ce4bdaa06dc39de08bba266d27  purpose-5.64.0.tar.xz
61fe5e1da6dd470fe9385f52f217df2b  syndication-5.64.0.tar.xz
317e43aaabd64bbe60910aee9aec5d45  kcalendarcore-5.64.0.tar.xz
c1fbdda16f5bde8ec80e95d72e941c42  kcontacts-5.64.0.tar.xz
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

done < frameworks-5.64.0.md5

exit


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

