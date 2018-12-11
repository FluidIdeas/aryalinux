#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="lightdm-webkit2-greeter"
DESCRIPTION="A webkit2 based greeter for lightdm"
VERSION=2.0.0

#REQ:git
#REQ:lightdm
#REC:aryalinux-wallpapers
#REC:aryalinux-fonts
#REC:aryalinux-themes
#REC:aryalinux-icons
#REQ:meson
#REQ:ninja
#REQ:webkitgtk

cd $SOURCE_DIR

rm -rf lightdm-webkit2-greeter
git clone https://github.com/Antergos/lightdm-webkit2-greeter.git
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.04/lightdm-webkit-material.tar.gz
cd lightdm-webkit2-greeter
git checkout stable
cd build
meson --prefix=/usr --libdir=lib ..
ninja
sudo ninja install

sudo mkdir -pv /usr/share/lightdm-webkit/themes/
sudo tar xf ../../lightdm-webkit-material.tar.gz -C /usr/share/lightdm-webkit/themes/

sudo tee -a /etc/lightdm/lightdm-webkit2-greeter.conf << EOF
#
# [greeter]
# debug_mode          = Greeter theme debug mode.
# detect_theme_errors = Provide an option to load a fallback theme when theme errors are detected.
# screensaver_timeout = Blank the screen after this many seconds of inactivity.
# secure_mode         = Don't allow themes to make remote http requests.
# time_format         = A moment.js format string so the greeter can generate localized time for display.
# time_language       = Language to use when displaying the time or "auto" to use the system's language.
# webkit_theme        = Webkit theme to use.
#
# NOTE: See moment.js documentation for format string options: http://momentjs.com/docs/#/displaying/format/
#

[greeter]
debug_mode          = false
detect_theme_errors = true
screensaver_timeout = 300
secure_mode         = true
time_format         = LT
time_language       = auto
webkit_theme        = lightdm-webkit-material

#
# [branding]
# background_images = Path to directory that contains background images for use by themes.
# logo              = Path to logo image for use by greeter themes.
# user_image        = Default user image/avatar. This is used by themes for users that have no .face image.
#
# NOTE: Paths must be accessible to the lightdm system user account (so they cannot be anywhere in /home)
#

[branding]
background_images = /usr/share/backgrounds
logo              = /usr/share/lightdm-webkit/themes/antergos/img/antergos.png
user_image        = /usr/share/lightdm-webkit/themes/antergos/img/antergos-logo-user.png
EOF

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
