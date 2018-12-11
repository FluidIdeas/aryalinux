#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Ekiga is a VoIP, IP Telephony, andbr3ak Video Conferencing application that allows you to make audio andbr3ak video calls to remote users with SIP or H.323 compatible hardwarebr3ak and software. It supports many audio and video codecs and allbr3ak modern VoIP features for both SIP and H.323. Ekiga is the first Open Source application tobr3ak support both H.323 and SIP, as well as audio and video.br3ak"
SECTION="xsoft"
VERSION=4.0.1
NAME="ekiga"

#REQ:boost
#REQ:gnome-icon-theme
#REQ:gtk2
#REQ:opal
#REC:dbus-glib
#REC:GConf
#REC:libnotify
#OPT:avahi
#OPT:evolution-data-server
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ekiga/ekiga-4.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-eds     \
            --disable-gdu     \
            --disable-ldap    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
