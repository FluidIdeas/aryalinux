#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Shadow was indeed installed in LFSbr3ak and there is no reason to reinstall it unless you installedbr3ak CrackLib or Linux-PAM after your LFS system was completed.br3ak If you have installed CrackLibbr3ak after LFS, then reinstalling Shadow will enable strong password support. Ifbr3ak you have installed Linux-PAM,br3ak reinstalling Shadow will allowbr3ak programs such as <span class=\"command\"><strong>login</strong> and <span class=\"command\"><strong>su</strong> to utilize PAM.br3ak"
SECTION="postlfs"
VERSION=4.6
NAME="shadow"

#REQ:linux-pam
#REQ:cracklib


cd $SOURCE_DIR

URL=https://github.com/shadow-maint/shadow/releases/download/4.6/shadow-4.6.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/shadow-maint/shadow/releases/download/4.6/shadow-4.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/shadow/shadow-4.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/shadow/shadow-4.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/shadow/shadow-4.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/shadow/shadow-4.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/shadow/shadow-4.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/shadow/shadow-4.6.tar.xz

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

sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs


sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs &&
sed -i 's/1000/999/' etc/useradd                           &&
./configure --sysconfdir=/etc --with-group-name-max-length=32 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/bin/passwd /bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i 's/yes/no/' /etc/default/useradd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 /etc/login.defs /etc/login.defs.orig &&
for FUNCTION in FAIL_DELAY               \
                FAILLOG_ENAB             \
                LASTLOG_ENAB             \
                MAIL_CHECK_ENAB          \
                OBSCURE_CHECKS_ENAB      \
                PORTTIME_CHECKS_ENAB     \
                QUOTAS_ENAB              \
                CONSOLE MOTD_FILE        \
                FTMP_FILE NOLOGINS_FILE  \
                ENV_HZ PASS_MIN_LEN      \
                SU_WHEEL_ONLY            \
                CRACKLIB_DICTPATH        \
                PASS_CHANGE_TRIES        \
                PASS_ALWAYS_WARN         \
                CHFN_AUTH ENCRYPT_METHOD \
                ENVIRON_FILE
do
    sed -i "s/^${FUNCTION}/# &/" /etc/login.defs
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login
# Set failure delay before next prompt to 3 seconds
auth optional pam_faildelay.so delay=3000000
# Check to make sure that the user is allowed to login
auth requisite pam_nologin.so
# Check to make sure that root is allowed to login
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth required pam_securetty.so
# Additional group memberships - disabled by default
#auth optional pam_group.so
# include the default auth settings
auth include system-auth
# check access for the user
account required pam_access.so
# include the default account settings
account include system-account
# Set default environment variables for the user
session required pam_env.so
# Set resource limits for the user
session required pam_limits.so
# Display date of last login - Disabled by default
#session optional pam_lastlog.so
# Display the message of the day - Disabled by default
#session optional pam_motd.so
# Check user's mail - Disabled by default
#session optional pam_mail.so standard quiet
# include the default session and password settings
session include system-session
password include system-password
# End /etc/pam.d/login
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd
password include system-password
# End /etc/pam.d/passwd
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su
# always allow root
auth sufficient pam_rootok.so
auth include system-auth
# include the default account settings
account include system-account
# Set default environment variables for the service user
session required pam_env.so
# include system session defaults
session include system-session
# End /etc/pam.d/su
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/chage << "EOF"
# Begin /etc/pam.d/chage
# always allow root
auth sufficient pam_rootok.so
# include system defaults for auth account and session
auth include system-auth
account include system-account
session include system-session
# Always permit for authentication updates
password required pam_permit.so
# End /etc/pam.d/chage
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for PROGRAM in chfn chgpasswd chpasswd chsh groupadd groupdel \
               groupmems groupmod newusers useradd userdel usermod
do
    install -v -m644 /etc/pam.d/chage /etc/pam.d/${PROGRAM}
    sed -i "s/chage/$PROGRAM/" /etc/pam.d/${PROGRAM}
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /run/nologin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
[ -f /etc/login.access ] && mv -v /etc/login.access{,.NOUSE}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
[ -f /etc/limits ] && mv -v /etc/limits{,.NOUSE}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
