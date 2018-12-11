#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:installing
#OPT:gdk-pixbuf
#OPT:startup-notification

cd $SOURCE_DIR

wget -nc http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2

URL=http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.22.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr --enable-everything &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/X11/app-defaults/URxvt << "EOF"
<code class="literal">! Use the specified colour as the windows background colour [default white] URxvt*background: black ! Use the specified colour as the windows foreground colour [default black] URxvt*foreground: yellow ! Select the fonts to be used. This is a comma separated list of font names URxvt*font: xft:Monospace:pixelsize=18 ! Comma-separated list(s) of perl extension scripts (default: "default") URxvt*perl-ext: matcher ! Specifies the program to be started with a URL argument. Used by URxvt*url-launcher: firefox ! When clicked with the mouse button specified in the "matcher.button" resource ! (default 2, or middle), the program specified in the "matcher.launcher" ! resource (default, the "url-launcher" resource, "sensible-browser") will be ! started with the matched text as first argument. ! Below, default modified to mouse left button. URxvt*matcher.button: 1</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

xrdb -query
xrdb -merge ~/.Xresources
<code class="literal"># Start the urxvtd daemon urxvtd -q -f -o &</code>

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /usr/share/applications/urxvt.desktop << "EOF" &&
<code class="literal">[Desktop Entry] Encoding=UTF-8 Name=Rxvt-Unicode Terminal Comment=Use the command line GenericName=Terminal Exec=urxvt Terminal=false Type=Application Icon=utilities-terminal Categories=GTK;Utility;TerminalEmulator; #StartupNotify=true Keywords=console;command line;execute;</code>
EOF

update-desktop-database -q
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
