#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Chromium is an open-source browserbr3ak project that aims to build a safer, faster, and more stable way forbr3ak all users to experience the web.br3ak"
SECTION="xsoft"
VERSION=64.0.3282.186
NAME="chromium"

#REQ:alsa-lib
#REQ:cups
#REQ:desktop-file-utils
#REQ:dbus
#REQ:perl-modules#perl-file-basedir
#REQ:gtk3
#REQ:hicolor-icon-theme
#REQ:mitkrb
#REQ:mesa
#REQ:nodejs
#REQ:nss
#REQ:python2
#REQ:usbutils
#REQ:xorg-server
#REC:make-ca
#REC:flac
#REC:git
#REC:TTF-and-OTF-fonts#liberation-fonts
#REC:libexif
#REC:libjpeg
#REC:libsecret
#REC:libwebp
#REC:pciutils
#REC:pulseaudio
#REC:xdg-utils
#REC:yasm
#OPT:ffmpeg
#OPT:GConf
#OPT:icu
#OPT:gnome-keyring
#OPT:libevent
#OPT:libpng
#OPT:libvpx
#OPT:libxml2
#OPT:upower


cd $SOURCE_DIR

URL=https://commondatastorage.googleapis.com/chromium-browser-official/chromium-64.0.3282.186.tar.xz

if [ ! -z $URL ]
then
wget -nc https://commondatastorage.googleapis.com/chromium-browser-official/chromium-64.0.3282.186.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-64.0.3282.186.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/chromium-64.0.3282.186-constexpr-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/chromium/chromium-64.0.3282.186-constexpr-1.patch

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

line='#define WIDEVINE_CDM_VERSION_STRING "Pinkie Pie"' 
sed "/WIDEVINE_CDM_AVAILABLE/a$line" \
    -i third_party/widevine/cdm/stub/widevine_cdm_version.h


sed '/static_assert/s:^://:' \
    -i third_party/WebKit/Source/platform/wtf/text/TextCodec.h


patch -Np1 -i ../chromium-64.0.3282.186-constexpr-1.patch


for LIB in flac freetype harfbuzz-ng libjpeg \
           libjpeg_turbo libwebp libxslt yasm; do
    find -type f -path "*third_party/$LIB/*"      \
        \! -path "*third_party/$LIB/chromium/*"   \
        \! -path "*third_party/$LIB/google/*"     \
        \! -path "*base/third_party/icu/*"        \
        \! -path './third_party/yasm/run_yasm.py' \
        \! -regex '.*\.\(gn\|gni\|isolate\|py\)'  \
        \! -path './third_party/freetype/src/src/psnames/pstables.h' \
        -delete
done &&
python build/linux/unbundle/replace_gn_files.py     \
    --system-libraries flac libjpeg libxml libevent \
                       libwebp libxslt opus yasm     &&
python third_party/libaddressinput/chromium/tools/update-strings.py


GN_CONFIG=('google_api_key="AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ"'
'google_default_client_id="595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com"'
'google_default_client_secret="5ntt6GbbkjnTVXx-MSxbmx5e"'
'clang_use_chrome_plugins=false'
'enable_hangout_services_extension=true'
'enable_nacl=false'
'enable_nacl_nonsfi=false'
'enable_swiftshader=false'
'enable_widevine=true'
'fatal_linker_warnings=false'
'ffmpeg_branding="Chrome"'
'fieldtrial_testing_like_official_build=true'
'is_debug=false'
'is_clang=false'
'link_pulseaudio=true'
'linux_use_bundled_binutils=false'
'proprietary_codecs=true'
'remove_webcore_debug_symbols=true'
'symbol_level=0'
'treat_warnings_as_errors=false'
'use_allocator="none"'
'use_cups=true'
'use_gconf=false'
'use_gnome_keyring=false'
'use_gold=false'
'use_gtk3=true'
'use_kerberos=true'
'use_pulseaudio=true'
'use_sysroot=false'
'use_system_freetype=true'
'use_system_harfbuzz=true')


python tools/gn/bootstrap/bootstrap.py --gn-gen-args "${GN_CONFIG[*]}" &&
out/Release/gn gen out/Release --args="${GN_CONFIG[*]}"


mkdir -p third_party/node/linux/node-linux-x64/bin &&
ln -s /usr/bin/node third_party/node/linux/node-linux-x64/bin/ &&
ninja -C out/Release chrome chrome_sandbox chromedriver widevinecdmadapter



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm755  out/Release/chrome \
                 /usr/lib/chromium/chromium                   &&
install -vDm4755 out/Release/chrome_sandbox \
                 /usr/lib/chromium/chrome-sandbox             &&
install -vDm755  out/Release/chromedriver \
                 /usr/lib/chromium/chromedriver               &&
ln -svf /usr/lib/chromium/chromium     /usr/bin               &&
ln -svf /usr/lib/chromium/chromedriver /usr/bin               &&
install -vDm644 out/Release/gen/content/content_resources.pak \
                /usr/lib/chromium/                            &&
install -vDm644 out/Release/icudtl.dat \
                /usr/lib/chromium/icudtl.dat                  &&
install -vDm644 out/Release/{*.pak,*.bin} \
                /usr/lib/chromium/                            &&
sed -i \
    -e "s/@@MENUNAME@@/Chromium/g" \
    -e "s/@@PACKAGE@@/chromium/g" \
    -e "s/@@USR_BIN_SYMLINK_NAME@@/chromium/g" \
    chrome/installer/linux/common/desktop.template \
    chrome/app/resources/manpage.1.in                         &&
install -vDm644 chrome/installer/linux/common/desktop.template \
                /usr/share/applications/chromium.desktop      &&
install -vDm644 chrome/app/resources/manpage.1.in \
                /usr/share/man/man1/chromium.1                &&
cp -av out/Release/locales /usr/lib/chromium/                 &&
chown -Rv root:root /usr/lib/chromium/locales                 &&
for size in 16 32; do
    install -vDm644 \
        "chrome/app/theme/default_100_percent/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done &&
for size in 22 24 48 64 128 256; do
    install -vDm644 "chrome/app/theme/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir temp                                         &&
cd temp                                            &&
case $(uname -m) in
    x86_64) ar -x ../../google-chrome-stable_64.0.3282.186-1_amd64.deb
    ;;
    i?86)   ar -x ../../google-chrome-stable_48.0.2564.116-1_i386.deb
    ;;
esac



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf data.tar.xz                                                        &&
install -vm755 ../out/Release/libwidevinecdmadapter.so /usr/lib/chromium/  &&
install -vm755 opt/google/chrome/libwidevinecdm.so  /usr/lib/chromium/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
