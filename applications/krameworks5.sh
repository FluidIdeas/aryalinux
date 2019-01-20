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
#OPT:modemmanager
#OPT:ttf-and-otf-fonts#oxygen-fonts
#OPT:ttf-and-otf-fonts#noto-fonts
#OPT:doxygen
#OPT:jinja2
#OPT:pyyaml
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
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

url=http://download.kde.org/stable/frameworks/5.53/
wget -r -nH -nd -A '*.xz' -np $url
cat > frameworks-5.53.0.md5 << "EOF"
56fbdc261e2821bb20775f1346d07321 attica-5.53.0.tar.xz
#a57cf2aa488fdcce7323a2a4b9aecb65 extra-cmake-modules-5.53.0.tar.xz
4ecdd6e9ab36b9bbdbe183f042eecb62 kapidox-5.53.0.tar.xz
81b62cf06f46166c16c194c88a2cc0fe karchive-5.53.0.tar.xz
968d1595082a3e167204a3b9585aa815 kcodecs-5.53.0.tar.xz
94c1924e39827a9bdfe19d1746383553 kconfig-5.53.0.tar.xz
#6c568d586c85e82b1d81221818862761 kcoreaddons-5.53.0.tar.xz
919bc0c53aa22cb45705ec1761198508 kcoreaddons-5.53.1.tar.xz
750d39201cca1bd29a1c6e10d33e77c0 kdbusaddons-5.53.0.tar.xz
b3547e0cca796eedfada7a850969f307 kdnssd-5.53.0.tar.xz
f2dee5c934be5a795c8caae2c9ef9c2f kguiaddons-5.53.0.tar.xz
95e67ba518ac2983e33ce8370bf0d3cd ki18n-5.53.0.tar.xz
176fb9a35f39ff79694c2a14be20ad44 kidletime-5.53.0.tar.xz
ea2af0d9b0b3cd76b2f78e929c417f6f kimageformats-5.53.0.tar.xz
f4d5826a20517d81387d20afb558ad0a kitemmodels-5.53.0.tar.xz
ec88c97513d84ce37de888721a3012bb kitemviews-5.53.0.tar.xz
34125fa1563feb9af831b1f7e05629ae kplotting-5.53.0.tar.xz
d73f5e3087bac6610b217df937024f5a kwidgetsaddons-5.53.0.tar.xz
6f7d0cc6d6fda9795035426ca14011ee kwindowsystem-5.53.0.tar.xz
0c55c1c31cc8c78b748d09cd5e4da395 networkmanager-qt-5.53.0.tar.xz
b7ca9416caae95bb56d72e062a31023b solid-5.53.0.tar.xz
fd28bda2bd2c1c0d40e477930394ed14 sonnet-5.53.0.tar.xz
58eda3124d5b24282e20471ed8275816 threadweaver-5.53.0.tar.xz
a98963e45c078d47f57e0f43c369baf2 kauth-5.53.0.tar.xz
113a86c053589b02024fe2e2052968b1 kcompletion-5.53.0.tar.xz
cabf02514d5ef0d5b25c44ff7d708ac3 kcrash-5.53.0.tar.xz
905d494671f33de9827c9a4467c0bdc7 kdoctools-5.53.0.tar.xz
102ec25afd116f79bb78699e3bf90bd7 kpty-5.53.0.tar.xz
89e6c4d46895f827fc36cab1b3782bf1 kunitconversion-5.53.0.tar.xz
295ec19de064d7ce1e0d5a89b8a21fbb kconfigwidgets-5.53.0.tar.xz
fd8aa91bad5b676a1d0c90588ff2220c kservice-5.53.0.tar.xz
ae6ea47653d2828821ec897b7e723134 kglobalaccel-5.53.0.tar.xz
532cd48d56e1adc7f716d4721a78bfe1 kpackage-5.53.0.tar.xz
253c8af01d93472f5940fd6f7fb33271 kdesu-5.53.0.tar.xz
cf48b7990b0026a6eb193bff21eb2ad8 kemoticons-5.53.0.tar.xz
234017ec51e4dc3f02989af75121e8f5 kiconthemes-5.53.0.tar.xz
3437728b6b9a09a59720d86392c05624 kjobwidgets-5.53.0.tar.xz
ec855d38c17ab4bba8d07b5e8532d6c7 knotifications-5.53.0.tar.xz
41089d37d64582213161d5ea55833afa ktextwidgets-5.53.0.tar.xz
b4c155182fd4ce55a40c9805fb405952 kxmlgui-5.53.0.tar.xz
f047e46e6b2ff7555a35678dbfaf06d5 kbookmarks-5.53.0.tar.xz
69bab15cc17486a5fcb73a811df6bd46 kwallet-5.53.0.tar.xz
23e7ef2aedfca8e77907d50d5bcfcb7e kio-5.53.0.tar.xz
89d9a968e01ad5c5937628dfc0b107f1 kdeclarative-5.53.0.tar.xz
62046f1c778dbc0cb1d4cdf2964006c6 kcmutils-5.53.0.tar.xz
66df9ccd7ad082f04aaa5d602f6c9744 kirigami2-5.53.0.tar.xz
f9b94bfbfc7658ff675c6f81085172f7 knewstuff-5.53.0.tar.xz
9957a52e9b75dd61a62f3ad7a61e299a frameworkintegration-5.53.0.tar.xz
f4c46a0a8e3e0cd7134c82895b47bb83 kinit-5.53.0.tar.xz
6df039f32bce1f4c0f487a8997526d2f knotifyconfig-5.53.0.tar.xz
81379bd6d6adf476d776c74874594c09 kparts-5.53.0.tar.xz
c05f22156c27da1ad2f7d2d07026b2e8 kactivities-5.53.0.tar.xz
8edde556c89c783dbd6bd9956f52e0cf kded-5.53.0.tar.xz
#fea737d2db9d792bdc24eb3de83276cc kdewebkit-5.53.0.tar.xz
62d67899a9cd5cd6b93761ebafd88942 syntax-highlighting-5.53.0.tar.xz
fec5ca67093aa83378d2b0daae131a43 ktexteditor-5.53.0.tar.xz
1d4e9805bb6d3748b01140fdb0ecff41 kdesignerplugin-5.53.0.tar.xz
89674cb577a239da0c6decddb62e8e28 kwayland-5.53.0.tar.xz
b083d295d7f2ba6236ca466b0cdaca64 plasma-framework-5.53.0.tar.xz
21d412157131d544fe2fd76e230af5e8 modemmanager-qt-5.53.0.tar.xz
4a734ace32596aa1a08922a291dc117f kpeople-5.53.0.tar.xz
130b79df792e0cd4be15a0f9fec54278 kxmlrpcclient-5.53.0.tar.xz
a95dc95f2ab7b4892d3cb166516b6c73 bluez-qt-5.53.0.tar.xz
e2d2de67f9dcbdabc950ef0a3ad5d5c5 kfilemetadata-5.53.0.tar.xz
deed1d430e5c9b73008ca45c78df9ee3 baloo-5.53.0.tar.xz
#a556bc1666851b8437ccaafd8cefe1d2 breeze-icons-5.53.0.tar.xz
#0a7d75f573c34fc1d2781cea90c2074e oxygen-icons5-5.53.0.tar.xz
74f48c21cc7ccf14fcc441b7ec53ae65 kactivities-stats-5.53.0.tar.xz
284425457f8270e91e94d13d1a522cce krunner-5.53.0.tar.xz
#49f35779816680e7da357abba972ceb0 prison-5.53.0.tar.xz
b873771ad44ec37625a79d7a41e8679f qqc2-desktop-style-5.53.0.tar.xz
14303adfba7c862f0a7f4761f90d079b kjs-5.53.0.tar.xz
4cc726dd1c9633b8c41e64b6c41264d5 kdelibs4support-5.53.0.tar.xz
3c483e076a47512970fa887eaf50c276 khtml-5.53.0.tar.xz
91b293e616518e7603ef4063c748b324 kjsembed-5.53.0.tar.xz
2b0aa8e7fc91286e8b5df927f77babb8 kmediaplayer-5.53.0.tar.xz
690b0c422b7b22b7adf030be6a178e59 kross-5.53.0.tar.xz
680e4656504ef2fc0e25c6a60e53a39e kholidays-5.53.0.tar.xz
13631f878f957b8a5c3103336f856b92 purpose-5.53.0.tar.xz
0fe62a714eadf8e52a0f99e49ad647ae syndication-5.53.0.tar.xz
EOF
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5.old &&
install -v -dm755 $KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1 $KF5_PREFIX/etc &&
ln -sfv /usr/share/dbus-1 $KF5_PREFIX/share
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

bash -e
export CXXFLAGS='-isystem /usr/include/openssl-1.0'

while read -r line; do

# Get the file name, ignoring comments and blank lines
if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
file=$(echo $line | cut -d" " -f2)

pkg=$(echo $file|sed 's|^.*/||') # Remove directory
packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

tar -xf $file
pushd $packagedir
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
-DCMAKE_PREFIX_PATH=$QT5DIR \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_TESTING=OFF \
-Wno-dev ..
make
as_root make install
popd

as_root rm -rf $packagedir
as_root /sbin/ldconfig

done < frameworks-5.53.0.md5

exit

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5-5.53.0
ln -sfvn kf5-5.53.0 /opt/kf5
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
