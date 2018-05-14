#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="playonlinux"
VERSION="4.2.2"

#REQ:cabextract
#REQ:curl
#REQ:gnupg
#REQ:icoutils
#REQ:imagemagick
#REQ:mesa
#REQ:netcat
#REQ:p7zip-full
#REQ:wxpython
#REQ:unzip
#REQ:wget
#REQ:wine
#REQ:x7util
#REQ:xterm

URL=http://archive.ubuntu.com/ubuntu/pool/multiverse/p/playonlinux/playonlinux_4.2.2.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

# Copied from slackware slackbuild

cat > setupwindow.patch <<"EOF"
--- playonlinux/python/guiv3.py	2013-12-31 15:35:37.000000000 +0530
+++ playonlinux.copy/python/guiv3.py	2016-07-24 00:24:07.867291673 +0530
@@ -84,7 +84,7 @@
         self.oldfichier = ""
         
         self.make_gui()
-
+        self.SetSize(self.GetEffectiveMinSize())
         wx.EVT_CLOSE(self, self.Cancel)
 
     def make_gui(self):
EOF

cat > installwindow.patch <<"EOF"
--- install.py	2013-12-31 15:35:37.000000000 +0530
+++ install.py.new	2016-07-24 00:36:31.622073361 +0530
@@ -336,6 +336,7 @@
 
         #wx.EVT_CHECKBOX(self, 111, self.manual)
         #Timer, regarde toute les secondes si il faut actualiser la liste
+        self.SetSize(self.GetEffectiveMinSize())
 
     def TimerAction(self, event):
         if(self.lasthtml_content != self.description.htmlContent):
EOF

patch -Np1 -i setupwindow.patch python/guiv3.py
patch -Np1 -i installwindow.patch python/install.py

sudo chown -R root:root .
find . \
 \( -perm 777 -o -perm 775 -o -perm 711 -o -perm 555 -o -perm 511 \) \
 -exec sudo chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 600 -o -perm 444 -o -perm 440 -o -perm 400 \) \
 -exec sudo chmod 644 {} \;
find . -name '*~*' -exec sudo rm -rf {} \;

sudo mkdir -pv /usr/share/playonlinux
sudo cp -a * /usr/share/playonlinux

sudo mkdir -pv /usr/share/applications
sudo cp -a /usr/share/playonlinux/etc/PlayOnLinux.desktop /usr/share/applications/PlayOnLinux.desktop

sudo mkdir -pv /usr/share/pixmaps
sudo cp -a /usr/share/playonlinux/etc/playonlinux.png /usr/share/pixmaps/

sudo mkdir -pv /usr/bin
echo "#!/bin/bash" | sudo tee /usr/bin/playonlinux
echo "/usr/share/playonlinux/playonlinux \"\$@\"" | sudo tee -a /usr/bin/playonlinux
sudo chmod 0755 /usr/bin/playonlinux

sudo update-desktop-database
sudo update-mime-database /usr/share/mime

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
