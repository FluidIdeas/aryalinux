#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Slick greeter is a slick-looking LightDM greeter"
SECTION="xsoft"
VERSION=1.2.2
NAME="slick-greeter"

#REQ:lightdm

cd $SOURCE_DIR

URL=https://github.com/linuxmint/slick-greeter/archive/1.2.2.tar.gz

whoami > /tmp/currentuser

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY
./autogen.sh --prefix=/usr &&
make "-j`nproc`" || make
sudo make install

sudo tee /etc/lightdm/slick-greeter.conf << EOF
# LightDM GTK+ Configuration
# Available configuration options listed below.
#
# activate-numlock=Whether to activate numlock. This features requires the installation of numlockx. (true or false)
# background=Background file to use, either an image path or a color (e.g. #772953)
# background-color=Background color (e.g. #772953), set before wallpaper is seen
# draw-user-backgrounds=Whether to draw user backgrounds (true or false)
# draw-grid=Whether to draw an overlay grid (true or false)
# show-hostname=Whether to show the hostname in the menubar (true or false)
# show-power=Whether to show the power indicator in the menubar (true or false)
# show-a11y=Whether to show the accessibility options in the menubar (true or false)
# show-keyboard=Whether to show the keyboard indicator in the menubar (true or false)
# show-clock=Whether to show the clock in the menubar (true or false)
# show-quit=Whether to show the quit menu in the menubar (true or false)
# logo=Logo file to use
# other-monitors-logo=Logo file to use for other monitors
# theme-name=GTK+ theme to use
# icon-theme-name=Icon theme to use
# font-name=Font to use
# xft-antialias=Whether to antialias Xft fonts (true or false)
# xft-dpi=Resolution for Xft in dots per inch
# xft-hintstyle=What degree of hinting to use (hintnone/hintslight/hintmedium/hintfull)
# xft-rgba=Type of subpixel antialiasing (none/rgb/bgr/vrgb/vbgr)
# onscreen-keyboard=Whether to enable the onscreen keyboard (true or false)
# high-contrast=Whether to use a high contrast theme (true or false)
# screen-reader=Whether to enable the screen reader (true or false)
# play-ready-sound=A sound file to play when the greeter is ready
# hidden-users=List of usernames that are hidden until a special key combination is hit
# group-filter=List of groups that users must be part of to be shown (empty list shows all users)
# enable-hidpi=Whether to enable HiDPI support (on/off/auto)
# only-on-monitor=Sets the monitor on which to show the login window, -1 means "follow the mouse"
[Greeter]
background = /usr/share/backgrounds/aryalinux/pexels-photo-459059.jpeg
EOF
# Replacing the current greeter

greeter_line=$(grep "^greeter-session" /etc/lightdm/lightdm.conf)
sudo sed -i "s@$greeter_line@greeter-session=slick-greeter@g" /etc/lightdm/lightdm.conf

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
