#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Sudo package allows a systembr3ak administrator to give certain users (or groups of users) thebr3ak ability to run some (or all) commands as <code class=\"systemitem\">root or another user while logging the commandsbr3ak and arguments.br3ak"
SECTION="postlfs"
VERSION=1.8.23
NAME="sudo"

#OPT:linux-pam
#OPT:mitkrb
#OPT:openldap


cd $SOURCE_DIR

URL=http://www.sudo.ws/dist/sudo-1.8.23.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.sudo.ws/dist/sudo-1.8.23.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.23.tar.gz || wget -nc ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.23.tar.gz

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

./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.23 \
            --with-passprompt="[sudo] password for %p: " &&
make "-j`nproc`" || make


make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0


cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo
# include the default auth settings
auth include system-auth
# include the default account settings
account include system-account
# Set default environment variables for the service user
session required pam_env.so
# include system session defaults
session include system-session
# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
