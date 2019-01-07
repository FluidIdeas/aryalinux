#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR


NAME=tuning-fontconfig
VERSION=""
URL=""

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

mkdir -pv ~/.config/fontconfig &&
cat > ~/.config/fontconfig/fonts.conf << "EOF"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>

<match target="font" >
<!-- autohint was the old automatic hinter when hinting was patent
protected, so turn it off to ensure any hinting information in the font
itself is used, this is the default -->
<edit mode="assign" name="autohint"> <bool>false</bool></edit>

<!-- hinting is enabled by default -->
<edit mode="assign" name="hinting"> <bool>true</bool></edit>

<!-- for the lcdfilter see http://www.spasche.net/files/lcdfiltering/ -->
<edit mode="assign" name="lcdfilter"> <const>lcddefault</const></edit>

<!-- options for hintstyle:
hintfull: is supposed to give a crisp font that aligns well to the
character-cell grid but at the cost of its proper shape.

hintmedium: poorly documented, maybe a synonym for hintfull.
hintslight is the default: - supposed to be more fuzzy but retains shape.

hintnone: seems to turn hinting off.
The variations are marginal and results vary with different fonts -->
<edit mode="assign" name="hintstyle"> <const>hintslight</const></edit>

<!-- antialiasing is on by default and really helps for faint characters
and also for 'xft:' fonts used in rxvt-unicode -->
<edit mode="assign" name="antialias"> <bool>true</bool></edit>

<!-- subpixels are usually rgb, see
http://www.lagom.nl/lcd-test/subpixel.php -->
<edit mode="assign" name="rgba"> <const>rgb</const></edit>

<!-- thanks to the Arch wiki for the lcd and subpixel links -->
</match>

</fontconfig>
EOF

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/fonts/conf.d/70-no-bitmaps.conf << "EOF"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
<!-- Reject bitmap fonts -->
<selectfont>
<rejectfont>
<pattern>
<patelt name="scalable"><bool>false</bool></patelt>
</pattern>
</rejectfont>
</selectfont>
</fontconfig>
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/fonts/conf.d/09-texlive.conf << "EOF"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
<dir>/opt/texlive/2018/texmf-dist/fonts/opentype/arkandis/berenisadf</dir>
<dir>/opt/texlive/2018/texmf-dist/fonts/truetype/paratype</dir>
</fontconfig>
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir -pv ~/.config/fontconfig/conf.d &&
cat > ~/.config/fontconfig/conf.d/35-prefer-nimbus-for-timesnew.conf << "EOF"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
<!-- prefer Nimbus Roman No9 L for Times New Roman as well as for Times,
without this Tinos and Liberation Serif take precedence for Times New Roman
before fontconfig falls back to whatever matches Times -->
<alias binding="same">
<family>Times New Roman</family>
<accept>
<family>Nimbus Roman No9 L</family>
</accept>
</alias>
</fontconfig>
EOF

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/fonts/local.conf << "EOF"
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
<alias>
<family>serif</family>
<prefer>
<family>AR PL UMing</family>
<family>IPAexMincho</family>
<!-- WenQuanYi is preferred as Serif in 65-nonlatin.conf,
override that so a real Korean font can be used for Serif -->
<family>UnBatang</family>
</prefer>
</alias>
<alias>
<family>sans-serif</family>
<prefer>
<family>WenQuanYi Zen Hei</family>
<family>VL Gothic</family>
<family>IPAexGothic</family>
</prefer>
</alias>
<alias>
<family>monospace</family>
<prefer>
<family>VL Gothic</family>
<family>IPAexGothic</family>
<family>WenQuanYi Zen Hei</family>
</prefer>
</alias>
</fontconfig>
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
