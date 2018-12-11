#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Linux PAM package containsbr3ak Pluggable Authentication Modules used to enable the local systembr3ak administrator to choose how applications authenticate users.br3ak"
SECTION="postlfs"
VERSION=1.3.0
NAME="linux-pam"

#OPT:db
#OPT:cracklib
#OPT:libtirpc
#OPT:docbook
#OPT:docbook-xsl
#OPT:fop
#OPT:libxslt
#OPT:w3m


cd $SOURCE_DIR

URL=http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.3.0.tar.bz2
wget -nc http://linux-pam.org/documentation/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Linux-PAM/Linux-PAM-1.2.0-docs.tar.bz2

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

tar -xf ../Linux-PAM-1.2.0-docs.tar.bz2 --strip-components=1


./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --disable-regenerate-docu        \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.3.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /etc/pam.d &&
cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -fv /etc/pam.d/*

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 4755 /sbin/unix_chkpwd &&
for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /etc/pam.d &&
cat > /etc/pam.d/system-account << "EOF" &&
# Begin /etc/pam.d/system-account
account required pam_unix.so
# End /etc/pam.d/system-account
EOF
cat > /etc/pam.d/system-auth << "EOF" &&
# Begin /etc/pam.d/system-auth
auth required pam_unix.so
# End /etc/pam.d/system-auth
EOF
cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session
session required pam_unix.so
# End /etc/pam.d/system-session
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password
# check new passwords for strength (man pam_cracklib)
password required pam_cracklib.so type=Linux retry=3 difok=5 \
 difignore=23 minlen=9 dcredit=1 \
 ucredit=1 lcredit=1 ocredit=1 \
 dictpath=/lib/cracklib/pw_dict
# use sha512 hash for encryption, use shadow, and use the
# authentication token (chosen password) set by pam_cracklib
# above (or any previous modules)
password required pam_unix.so sha512 shadow use_authtok
# End /etc/pam.d/system-password
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password
# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password required pam_unix.so sha512 shadow try_first_pass
# End /etc/pam.d/system-password
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other
auth required pam_warn.so
auth required pam_deny.so
account required pam_warn.so
account required pam_deny.so
password required pam_warn.so
password required pam_deny.so
session required pam_warn.so
session required pam_deny.so
# End /etc/pam.d/other
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
