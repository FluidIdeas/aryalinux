#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ConsoleKit package is abr3ak framework for keeping track of the various users, sessions, andbr3ak seats present on a system. It provides a mechanism for software tobr3ak react to changes of any of these items or of any of the metadatabr3ak associated with them.br3ak"
SECTION="postlfs"
VERSION=1.0.2
NAME="consolekit"

#REQ:dbus-glib
#REQ:x7lib
#REC:linux-pam
#REC:polkit
#REC:pm-utils
#OPT:xmlto


cd $SOURCE_DIR

URL=https://github.com/Consolekit2/ConsoleKit2/releases/download/1.0.2/ConsoleKit2-1.0.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://github.com/Consolekit2/ConsoleKit2/releases/download/1.0.2/ConsoleKit2-1.0.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/consolekit/ConsoleKit2-1.0.2.tar.bz2

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-udev-acl    \
            --enable-pam-module  \
            --enable-polkit      \
            --with-xinitrc-dir=/etc/X11/app-defaults/xinitrc.d \
            --docdir=/usr/share/doc/ConsoleKit-1.0.2           \
            --with-systemdsystemunitdir=no                     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /etc/X11/app-defaults/xinitrc.d/90-consolekit{,.sh}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin ConsoleKit addition
session optional pam_loginuid.so
session optional pam_ck_connector.so nox11
# End ConsoleKit addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck << "EOF"
#!/bin/sh
TAGDIR=/var/run/console
[ -n "$CK_SESSION_USER_UID" ] || exit 1
[ "$CK_SESSION_IS_LOCAL" = "true" ] || exit 0
TAGFILE="$TAGDIR/`getent passwd $CK_SESSION_USER_UID | cut -f 1 -d:`"
if [ "$1" = "session_added" ]; then
    mkdir -p "$TAGDIR"
    echo "$CK_SESSION_ID" >> "$TAGFILE"
fi
if [ "$1" = "session_removed" ] && [ -e "$TAGFILE" ]; then
    sed -i "\%^$CK_SESSION_ID\$%d" "$TAGFILE"
    [ -s "$TAGFILE" ] || rm -f "$TAGFILE"
fi
EOF
chmod -v 755 /usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
