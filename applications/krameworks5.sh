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
VERSION=5.61

SECTION="KDE Frameworks 5"

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


url=http://download.kde.org/stable/frameworks/5.61/
wget -r -nH -nd -np -A '*.xz' $url
cat > frameworks-5.61.0.md5 << "EOF"
9ad93d635ed42f46ea5d0ba3d4922431  attica-5.61.0.tar.xz
#2f6f98d6c7cfd0d55eecd7516f415193  extra-cmake-modules-5.61.0.tar.xz
f972bac89585fd6ecbfa60285316ea65  kapidox-5.61.0.tar.xz
d8c20050abd157c665b5a6cd41a70d51  karchive-5.61.0.tar.xz
a0996305dec1ffc5228a2b03b688ba22  kcodecs-5.61.0.tar.xz
5aa453b71070a63837ba2b0e6f199fae  kconfig-5.61.0.tar.xz
b0b128fde7ab143de3f638d063411700  kcoreaddons-5.61.0.tar.xz
3d979f571e2b622e3e5e5cae0742ac0a  kdbusaddons-5.61.0.tar.xz
d89166c11d9d253c93bebf28e7687576  kdnssd-5.61.0.tar.xz
2c4769e8ca0dda1faa4f38484e6d889d  kguiaddons-5.61.0.tar.xz
576b52330b4f520613b1d0e59a28f24c  ki18n-5.61.0.tar.xz
53e175bb8168badcf7621f8fc118dd5e  kidletime-5.61.0.tar.xz
1d2789d6aebf2eb315a151631056b3a6  kimageformats-5.61.0.tar.xz
958f070cc6d0928dbee067ddca301b59  kitemmodels-5.61.0.tar.xz
2ba2ab1e56617c798f359155e44582c6  kitemviews-5.61.0.tar.xz
fe93d2709c8051599af633dda8aabe06  kplotting-5.61.0.tar.xz
706a9a215db46a8e086d63525763ce14  kwidgetsaddons-5.61.0.tar.xz
7f890d4583f0bb3e7f668ea8c8fbfc2d  kwindowsystem-5.61.0.tar.xz
74814129eed17c2611dfdce10369b965  networkmanager-qt-5.61.0.tar.xz
c9236f64de78c54d148270e85cd15a3d  solid-5.61.0.tar.xz
720d552ccb814fe0038342c8425163f2  sonnet-5.61.0.tar.xz
0be971c196d328f766c6c2b60aae0b21  threadweaver-5.61.0.tar.xz
73863244f37c68ff2042fd7039da9480  kauth-5.61.0.tar.xz
39c8b31802d32fe59bc9487a542bdb18  kcompletion-5.61.0.tar.xz
afd0f85ae16277ab081d4cac99ac2d05  kcrash-5.61.0.tar.xz
1857490f170337542bae5cda72f27b85  kdoctools-5.61.0.tar.xz
33b46dcce54439c3b9d05fff2788abad  kpty-5.61.0.tar.xz
5ec7713d7b7d2360903014e628b596bd  kunitconversion-5.61.0.tar.xz
ee1cf04225a7478a94442c9b4ee52224  kconfigwidgets-5.61.0.tar.xz
83a94d40e694cb32dd5ebe4166dc1c7f  kservice-5.61.0.tar.xz
6ebfee9fe099e3250b47ac59d7c624b2  kglobalaccel-5.61.0.tar.xz
84eaf54cdb480a108257772a77296514  kpackage-5.61.0.tar.xz
c471bdb119e220195d8419d5dbe8ee3b  kdesu-5.61.0.tar.xz
3c2c9f857e4f07489c217e22b75ad324  kemoticons-5.61.0.tar.xz
eafb575ee24c3d5856df5d0b5e97ad4e  kiconthemes-5.61.0.tar.xz
fa63977264e16079fd69c694ef61122e  kjobwidgets-5.61.0.tar.xz
a31859ea6498b2c9df2354c12877f0a9  knotifications-5.61.0.tar.xz
0906bd87ee084c95c3bb012d1ad4b68f  ktextwidgets-5.61.0.tar.xz
8c95b1077024b1768ae40b6f906b7c6c  kxmlgui-5.61.0.tar.xz
4f610828fb9aa410fce3f878908bac5b  kbookmarks-5.61.0.tar.xz
45f80f2454ec9cd7f7f7ec0ffc1a56ce  kwallet-5.61.0.tar.xz
884e6d240f179851c247ff498b258f45  kio-5.61.0.tar.xz
a2c5065aec2a192d7cfd978cea09be84  kdeclarative-5.61.0.tar.xz
c9f2b551f32221892d746feb9c6fc7f8  kcmutils-5.61.0.tar.xz
bf7a57a1088076a79e7992ca9be53018  kirigami2-5.61.0.tar.xz
1d2e4149a415d9b621edf03addeae55d  knewstuff-5.61.0.tar.xz
fb69e4769b4958e52213de614f3be5c5  frameworkintegration-5.61.0.tar.xz
f20ed3efe486b9a6b909ac8adf3c6c38  kinit-5.61.0.tar.xz
40689423f1452f9d7e05883cce93a7ec  knotifyconfig-5.61.0.tar.xz
7f01d6ae022e3ae0ea5c77442805394c  kparts-5.61.0.tar.xz
5a3c59535fd778bc8afd95dae121a957  kactivities-5.61.0.tar.xz
671f84a09bc489d863a1734043591ae2  kded-5.61.0.tar.xz
#9075fbe8ca7afcd8ca263dbe41a823b4  kdewebkit-5.61.0.tar.xz
4036e7bcb0c3fb6c5907d0efac365234  syntax-highlighting-5.61.0.tar.xz
07ea86451c4ddbe097d1e87fa161a0d0  ktexteditor-5.61.0.tar.xz
cea06789eb647b75c92f4b6a2f4016ba  kdesignerplugin-5.61.0.tar.xz
fab6a981a5c604d45466bdfce204848f  kwayland-5.61.0.tar.xz
d40534ff8a7f9abd595e2fcb93374472  plasma-framework-5.61.0.tar.xz
#b1854ae5022c5a41533f0dcac2ca2cb9  modemmanager-qt-5.61.0.tar.xz
7861b72a4f4d16f49d9a84f956c20386  kpeople-5.61.0.tar.xz
424f8d787c02dc1c9729171b2c591eb7  kxmlrpcclient-5.61.0.tar.xz
5596cd4e9a134cce689d24887912edfe  bluez-qt-5.61.0.tar.xz
911774517abc301a303e2e429c875d74  kfilemetadata-5.61.0.tar.xz
3ef703414987f2e494eee19d101c34e4  baloo-5.61.0.tar.xz
#bd2441e04540b82849fc3144dcd6dbca  breeze-icons-5.61.0.tar.xz
#a08326c6e10855f47e5f1b63c31f2f0e  oxygen-icons5-5.61.0.tar.xz
f98a2e990aa25b0e56ee0b50f8baf1e8  kactivities-stats-5.61.0.tar.xz
661d9760f81218d7eccd5dda0762e53c  krunner-5.61.0.tar.xz
#af2125c297606f167ce8b9a182e30526  prison-5.61.0.tar.xz
50f3acf3668529a5c77ae4d6edf8b7d7  qqc2-desktop-style-5.61.0.tar.xz
c95e4ec5fb82dc53627ddcddd5b5ec10  kjs-5.61.0.tar.xz
7ee8ec810e00830dfeeb924c1b9242d0  kdelibs4support-5.61.0.tar.xz
fe66740ed0df257c1695eb0abd8ca9ed  khtml-5.61.0.tar.xz
8895a81c6b993e901de031c67a261464  kjsembed-5.61.0.tar.xz
4f6bd8b8a44295e2470fbd73816a8cdc  kmediaplayer-5.61.0.tar.xz
f7d9d1b5089dddafd9a55bdec47d1fbf  kross-5.61.0.tar.xz
591b24c0a31a5b9ba86a73e6cffdf4a9  kholidays-5.61.0.tar.xz
008208928903b40a2fdee3e1fcfa4448  purpose-5.61.0.tar.xz
fd8a4690fb00e3e627554394d948a1f7  syndication-5.61.0.tar.xz
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

done < frameworks-5.61.0.md5



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

