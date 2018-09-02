#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

ARCH=$(uname -m)

if [ $ARCH == "x86_64" ]
then
	URL=http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/photon/R/eclipse-jee-photon-R-linux-gtk-x86_64.tar.gz
else
	URL=http://eclipse.stu.edu.tw/technology/epp/downloads/release/neon/R/eclipse-jee-neon-R-linux-gtk.tar.gz
fi

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /opt/
sudo tee /etc/profile.d/eclipse.sh<<"EOF"
export SWT_GTK3=0
pathappend /opt/eclipse
EOF

sudo tee /usr/share/applications/eclipse.desktop <<"EOF"
[Desktop Entry]
Name=Eclipse IDE
GenericName=Eclipse IDE
Comment=Programming in Java
Exec=/opt/eclipse/eclipse
Icon=eclipse.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Java;Development;Debugger;
EOF

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
