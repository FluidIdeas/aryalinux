#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Final steps, before starting LXQt.br3ak"
SECTION="lxqt"
NAME="post-install"

#REQ:openbox
#REQ:xfwm4
#REQ:plasma-all
#REQ:icewm
#REC:lightdm
#REC:lxdm
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:xdg-utils
#REC:xscreensaver


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -svfn $LXQT_PREFIX/share/lxqt /usr/share/lxqt &&
cp -v {$LXQT_PREFIX,/usr}/share/xsessions/lxqt.desktop &&
for i in $LXQT_PREFIX/share/applications/*
do
  ln -svf $i /usr/share/applications/
done
for i in $LXQT_PREFIX/share/desktop-directories/*
do
  ln -svf $i /usr/share/desktop-directories/
done
unset i
ldconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime          &&
xdg-icon-resource forceupdate --theme hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.xinitrc << "EOF"
dbus-launch --exit-with-session startlxqt
EOF
startx


startx &> ~/.x-session-errors




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
