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

wget -nc http://download.kde.org/stable/frameworks/5.60


NAME=krameworks5
VERSION=5.60
URL=http://download.kde.org/stable/frameworks/5.60

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


url=http://download.kde.org/stable/frameworks/5.60/
wget -r -nH -nd -A '*.xz' -np $url
cat > frameworks-5.60.0.md5 << "EOF"
51e0f8be234e1c310205d5c6f782e537  attica-5.60.0.tar.xz
#faa5121d68c6d43f1340c1a1c8254ae4  extra-cmake-modules-5.60.0.tar.xz
7f4cb9f495177d46bb6057dc495736a0  kapidox-5.60.0.tar.xz
cb8d65acddcd0eb582a77773b2de0e46  karchive-5.60.0.tar.xz
7e9d9482b52b729328e06321e2989152  kcodecs-5.60.0.tar.xz
7f80691fc6b32e04f3ea13be77edb5af  kconfig-5.60.0.tar.xz
84410b718286b24577b78bc07084739d  kcoreaddons-5.60.0.tar.xz
aa5b30d820742d541a6bec3579f90dd1  kdbusaddons-5.60.0.tar.xz
b405fec215786e15a798948a07a592f9  kdnssd-5.60.0.tar.xz
4a524ebb83ce9b1b39a54d0aa39e7466  kguiaddons-5.60.0.tar.xz
0cf6a6c0a4aa8427763a1d8bb61a88e2  ki18n-5.60.0.tar.xz
54923408c39459922b616b92ce2678c9  kidletime-5.60.0.tar.xz
bd8b91a8a86d438cf8ee28b0012b0d7c  kimageformats-5.60.0.tar.xz
5ac5d11f5edc55d11b4ed81ead58a9bf  kitemmodels-5.60.0.tar.xz
f9ebdaf2965265d0da9ebbc79bbba592  kitemviews-5.60.0.tar.xz
54c6fb70ddd04f37e5f063e8d0960b1b  kplotting-5.60.0.tar.xz
e788ac09828cadec194ebf186156b205  kwidgetsaddons-5.60.0.tar.xz
e4ccac16de6c18728219c83528a8ee17  kwindowsystem-5.60.0.tar.xz
8242f78a39142afafbfce3b09a1fe974  networkmanager-qt-5.60.0.tar.xz
08e4b5b41fef66de9fb82d9e44cdfd4f  solid-5.60.0.tar.xz
2ca92137613156e24367eb3349e0e5b8  sonnet-5.60.0.tar.xz
81cfb42e1c9824bf2d7c7f0491bee8dd  threadweaver-5.60.0.tar.xz
00330dac282b372701a3f81de66c2e01  kauth-5.60.0.tar.xz
30d0925015e0e80de704aef5571d6897  kcompletion-5.60.0.tar.xz
1509f9fe4d665ca4c8fd660a3feaf92c  kcrash-5.60.0.tar.xz
1c4ceaa9e577e0a92890273e09f6b686  kdoctools-5.60.0.tar.xz
a3ec717d5460e92e3e40fae3253237d6  kpty-5.60.0.tar.xz
c866421ae6caa2de41ba862d5a30b577  kunitconversion-5.60.0.tar.xz
3a2876bcce59ee0ee3a002223e968d69  kconfigwidgets-5.60.0.tar.xz
eca6ef1e76cba2a00ce9b0f6e6f04d00  kservice-5.60.0.tar.xz
0a9f5dad0de04a9667fc636c5cae5637  kglobalaccel-5.60.0.tar.xz
319f7b14242a54445da1df6c6938fb3d  kpackage-5.60.0.tar.xz
76da218e8eba07af12681ed1ffc31c09  kdesu-5.60.0.tar.xz
2a846ab3041e4aa90545776f72974ce4  kemoticons-5.60.0.tar.xz
46d14353205a2f91a25a0bd9d2fbae7d  kiconthemes-5.60.0.tar.xz
03b511db466b456db8543b8732ecdb8a  kjobwidgets-5.60.0.tar.xz
95761f0597f907f9b2ba607a5ef6ac4a  knotifications-5.60.0.tar.xz
7f3a72982fc9ac89dbe1cf16802b7ec9  ktextwidgets-5.60.0.tar.xz
6839d8333aa4614dcb9cd9b67954cf1b  kxmlgui-5.60.0.tar.xz
b8cda472f958016a6701e39bffceba93  kbookmarks-5.60.0.tar.xz
e2b8a68528fb27281fea81273401f853  kwallet-5.60.0.tar.xz
e1c8bf207ee1721d8537c78a7dc4f166  kio-5.60.0.tar.xz
a5771426388ea795994300ec2489e557  kdeclarative-5.60.0.tar.xz
1348201acbc60eb0056f2212bb70c9d9  kcmutils-5.60.0.tar.xz
a324faf4223316f6bd92973d2efdaa4e  kirigami2-5.60.0.tar.xz
c941d34b251e12edb8dbe2170c5f6806  knewstuff-5.60.0.tar.xz
231174e4b7eab864b072f381ee61a08d  frameworkintegration-5.60.0.tar.xz
4424e0f90e61690f85b282c8f27f81b3  kinit-5.60.0.tar.xz
7764436e1c48baec765ad6f3ab5cc8e7  knotifyconfig-5.60.0.tar.xz
b905c041765c9a86083765d246bf950f  kparts-5.60.0.tar.xz
9649a8395c83b28d03f27538cecdde1b  kactivities-5.60.0.tar.xz
855f272f93f4ee40bbd1755f671258d4  kded-5.60.0.tar.xz
#4c144d0de38bd6f7e7e8a0a9589ee2dd  kdewebkit-5.60.0.tar.xz
db65057619ecd72a118e739b8a3d2c63  syntax-highlighting-5.60.0.tar.xz
46a45573dd2d86e5291d0d1b8f7890c4  ktexteditor-5.60.0.tar.xz
13090edbedfdbf0aa5385b9d5b77240f  kdesignerplugin-5.60.0.tar.xz
ebd69263c6d65ef59b3a70b7ae2bbae8  kwayland-5.60.0.tar.xz
796bac344bf8b8be90cc988131174a95  plasma-framework-5.60.0.tar.xz
#43693095957a309dfb210dfb81cfacf1  modemmanager-qt-5.60.0.tar.xz
2858ad1992c827e0a362a83f8c1fa775  kpeople-5.60.0.tar.xz
d0512509da62c45ebb907cf2e801133b  kxmlrpcclient-5.60.0.tar.xz
a84ced1bdca1522b3b67e024dca63b26  bluez-qt-5.60.0.tar.xz
a2e12f7d2cfe18ac3c6fee74214f068b  kfilemetadata-5.60.0.tar.xz
8d16dc04d79a5a497ad7e5e0db4d49cc  baloo-5.60.0.tar.xz
#22b5dd5c8cb259e55fc7f716dabfb8fb  breeze-icons-5.60.0.tar.xz
#d8df70afbad34688c65d98894f9f1a85  oxygen-icons5-5.60.0.tar.xz
620ca68051b8e364e13269cdde122f14  kactivities-stats-5.60.0.tar.xz
ca6908f6051065bb00c6f523af96c9a6  krunner-5.60.0.tar.xz
#e049ed74bc0a048aae9eee0639f06cb1  prison-5.60.0.tar.xz
ffc71a9259281545065468fdedf05f7e  qqc2-desktop-style-5.60.0.tar.xz
43732f9ed73d445d86d00297e9a9cf4e  kjs-5.60.0.tar.xz
d6e1642be773e68edf50abdd4af69b14  kdelibs4support-5.60.0.tar.xz
0db0a677e7fd00405ccb63994355bd42  khtml-5.60.0.tar.xz
940dd5ebce78989830e8b306f3738f92  kjsembed-5.60.0.tar.xz
536810eb862003483cdaadfb1b29068d  kmediaplayer-5.60.0.tar.xz
babd193992c4865ea2eeba9f0c91f988  kross-5.60.0.tar.xz
5579896a41729bff9fa94e4e46f0b72c  kholidays-5.60.0.tar.xz
4455d785c8bf317cacf3989f1394fada  purpose-5.60.0.tar.xz
09a13fd121a487144178a8384d0106d0  syndication-5.60.0.tar.xz
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

done < frameworks-5.60.0.md5

exit


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

