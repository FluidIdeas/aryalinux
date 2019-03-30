#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:kf5-intro
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
#REQ:noto-fonts
#REQ:oxygen-fonts
#REQ:bluez
#REQ:modemmanager
#REQ:jasper
#REQ:mitkrb
#REQ:udisks2
#REQ:upower
#REQ:media-player-info
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt

cd $SOURCE_DIR



NAME=krameworks5
VERSION=5.53
URL=

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

touch krameworks5.log
. /etc/profile.d/qt5.sh
. /etc/profile.d/kf5.sh

url=http://download.kde.org/stable/frameworks/5.55/
wget -nc -r -nH -nd -A '*.xz' -np $url
cat > frameworks-5.55.0.md5 << "EOF"
c6ea8536f0886a83c89036c26c141cfe attica-5.55.0.tar.xz
#f8efb80c1c3c4bfe3ada218fa1eb6daa extra-cmake-modules-5.55.0.tar.xz
1d51d64bfaa08b852f93b70be6bb0f8b kapidox-5.55.0.tar.xz
9feb5965a5438ea7900b10b6734b6b5d karchive-5.55.0.tar.xz
9cf8636f8ecd5699dc4cff2cd003bdaa kcodecs-5.55.0.tar.xz
83c4f3c39797bb014ae3d8addda3ee84 kconfig-5.55.0.tar.xz
b84b0d269fbbf63dba84ba7b345ab77f kcoreaddons-5.55.0.tar.xz
fbcc4a6e4daaf8dbbb623c8e58f48748 kdbusaddons-5.55.0.tar.xz
305545c320e2bd3901ca42a5d2a390fe kdnssd-5.55.0.tar.xz
86cdc362ac9b086762725ce50ad02254 kguiaddons-5.55.0.tar.xz
e22ba2c4be9a642d52202941f311092f ki18n-5.55.0.tar.xz
b1be65f6c85633f98e13555fdf185ec7 kidletime-5.55.0.tar.xz
6d89478ffa273724e47d937cf88715ef kimageformats-5.55.0.tar.xz
045f5c3b771e03c4d7d3ed8a61cce555 kitemmodels-5.55.0.tar.xz
57f6924d2811f47b7805529f66a74f8b kitemviews-5.55.0.tar.xz
0f6c2f958cf17b8f3d1f1ae41511e4f1 kplotting-5.55.0.tar.xz
cec11096084112885bb70c8af54b6c18 kwidgetsaddons-5.55.0.tar.xz
47b9fdf114802c1618be3a808d3fb5f9 kwindowsystem-5.55.0.tar.xz
cbc3ebe49b84228d4bea3b9f7dcb9638 networkmanager-qt-5.55.0.tar.xz
d9d13af96a11f19b68a8787b07a9a8c4 solid-5.55.0.tar.xz
9c2820d220904d527568ac3fd0ef901a sonnet-5.55.0.tar.xz
c78281f2572886467e906c7441673930 threadweaver-5.55.0.tar.xz
9caa8c9db684df909a404c987b20bcd2 kauth-5.55.0.tar.xz
51cfb4f5aafea5e85fb962da96e7eac3 kcompletion-5.55.0.tar.xz
44f4b49602863fcfbaa2b142d913ebe2 kcrash-5.55.0.tar.xz
bab2d57e0f7d0654e1c551c2c4e27a12 kdoctools-5.55.0.tar.xz
e6095ee56197b9d67c1393ba53c7d3d0 kpty-5.55.0.tar.xz
4476d603af984cb6322a9f831a906c41 kunitconversion-5.55.0.tar.xz
5f36ce8b06f046d14309afba6307531d kconfigwidgets-5.55.0.tar.xz
2b7a006d241718cb3c411a42c67c84b4 kservice-5.55.0.tar.xz
b7efe78d929ce60c2f6d6f91ffb99da5 kglobalaccel-5.55.0.tar.xz
d49e0c95cc12e210705f843b8c8ae624 kpackage-5.55.0.tar.xz
3b9f611ebb82225cd9021f3d8ba65d4e kdesu-5.55.0.tar.xz
a088d5a2316ce177c17823a7383216e3 kemoticons-5.55.0.tar.xz
fcabfaf2a08be0bee4317dd7b48a46ac kiconthemes-5.55.0.tar.xz
550af897cf2b536c0b3370c414f2e607 kjobwidgets-5.55.0.tar.xz
c6f26a73d4ea4835afbc07dd30f24f1b knotifications-5.55.0.tar.xz
104ea71b7a1495649a6c2b10ec76d49a ktextwidgets-5.55.0.tar.xz
ee8eb1f361e86568f8d63e3eef52c3d9 kxmlgui-5.55.0.tar.xz
2c6edfead8cbea6eb513b69bd81f352f kbookmarks-5.55.0.tar.xz
e9aea329a955d888363452ef57dd351b kwallet-5.55.0.tar.xz
5ea8d5b98580eea963e20466fd0949cd kio-5.55.0.tar.xz
df0b9df0c1241debaeae2acc634ce917 kdeclarative-5.55.0.tar.xz
b6903266cb40093a903e3f745c0b45dc kcmutils-5.55.0.tar.xz
bf939786cff333aa2d4c25502e4b2d08 kirigami2-5.55.0.tar.xz
b79143c6c4aa5f5e207c4513bcce0eb8 knewstuff-5.55.0.tar.xz
56cadbbd46a2b489fe43f063090fc1ce frameworkintegration-5.55.0.tar.xz
398d370cfc7060dbd8a2fa31d36a73f7 kinit-5.55.0.tar.xz
fb2aa145caf992e812de648d77dc3d6d knotifyconfig-5.55.0.tar.xz
2be64b9dab33e65523b0a113f95f5fdd kparts-5.55.0.tar.xz
e643d57385e5bddb12cba895af11f93e kactivities-5.55.0.tar.xz
a53b413d3bd78f90af64da9c6433ffdb kded-5.55.0.tar.xz
#9e573a2efc794c7b2056a09ac21113f4 kdewebkit-5.55.0.tar.xz
40c0bfab00d45324d232d94001903126 syntax-highlighting-5.55.0.tar.xz
188a9f7d092c93bf06259baf0e83f7d7 ktexteditor-5.55.0.tar.xz
15ec5f8445a23415a1f51980d1dd40c8 kdesignerplugin-5.55.0.tar.xz
3238b6fe1c25908de1b38452f206b0a8 kwayland-5.55.0.tar.xz
2afbba41e0f841b1775b0f002dbf2eca plasma-framework-5.55.0.tar.xz
#e605734af73a902175fcafd3de312ec8 modemmanager-qt-5.55.0.tar.xz
b0dbb756aff5bc0c811411573d43dc5c kpeople-5.55.0.tar.xz
22e294d6a362245a0b9a9da19eb84262 kxmlrpcclient-5.55.0.tar.xz
3242b966706240f90da8c22b0a7e007c bluez-qt-5.55.0.tar.xz
1d3f694c8a8a3a71a51ddb7f9172794a kfilemetadata-5.55.0.tar.xz
dbcac71cf905d6e282d04964ddd93e9f baloo-5.55.0.tar.xz
#6830eded1a3222a3dd91ba16d9fd8f60 breeze-icons-5.55.0.tar.xz
#a8a6e3889a0b1507bbb16d1c62619438 oxygen-icons5-5.55.0.tar.xz
5c6c869f871520f53eaf043415b39765 kactivities-stats-5.55.0.tar.xz
32c65a65016c944a02060f75d65dbf3b krunner-5.55.0.tar.xz
#c09b474c3f96c20504834b5df84c54f1 prison-5.55.0.tar.xz
46ff1ecbdcd631b1a88bc8789b362c1b qqc2-desktop-style-5.55.0.tar.xz
bdcbb64afef6a317eadfbfe3e8f08036 kjs-5.55.0.tar.xz
8f936d42df6edc311758a2be928b3f32 kdelibs4support-5.55.0.tar.xz
a91b430e12c09d01ec2a67d711737609 khtml-5.55.0.tar.xz
f5b31ebf9337ee041f2fd9ef05df1494 kjsembed-5.55.0.tar.xz
f3bad578dc409b557d63cf7f058bd5c9 kmediaplayer-5.55.0.tar.xz
652b408be88fc8dde4dd6c2cf053588d kross-5.55.0.tar.xz
a28376dc7e56982df710307bef1a63e8 kholidays-5.55.0.tar.xz
bfd74337cb26fe7f011de0eca4f08ffe purpose-5.55.0.tar.xz
450567c456f2215cc02ec70c941d5744 syndication-5.55.0.tar.xz
EOF
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
while read -r line; do

if grep $line krameworks5.log &> /dev/null; then continue; fi

# Get the file name, ignoring comments and blank lines
if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
file=$(echo $line | cut -d" " -f2)

pkg=$(echo $file|sed 's|^.*/||') # Remove directory
packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

# Fix a security issue in kcodecs
name=$(echo $pkg|sed 's|-5.*$||') # Isolate package name

if [ "$name" == "kcodecs" ]; then
sed -i '/int ISO2022JPChar/s/}/, 0, 0}/' src/probers/nsEscSM.cpp
fi

tar -xf $file
pushd $packagedir
mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_PREFIX_PATH=$QT5DIR \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_TESTING=OFF \
-Wno-dev ..
make
as_root make install
popd

as_root rm -rf $packagedir
as_root /sbin/ldconfig

echo $line >> krameworks5.log
done < frameworks-5.55.0.md5


rm $SOURCE_DIR/krameworks5.log

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
