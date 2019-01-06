#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:linux-pam
#OPT:mitkrb
#OPT:openldap
#OPT:mail

cd $SOURCE_DIR

wget -nc http://www.sudo.ws/dist/sudo-1.8.26.tar.gz
wget -nc ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.26.tar.gz

NAME=sudo
VERSION=1.8.26
URL=http://www.sudo.ws/dist/sudo-1.8.26.tar.gz

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

./configure --prefix=/usr \
--libexecdir=/usr/lib \
--with-secure-path \
--with-all-insults \
--with-env-editor \
--docdir=/usr/share/doc/sudo-1.8.26 \
--with-passprompt="[sudo] password for %p: " &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/sudoers.d/sudo << "EOF"
<code class="literal">Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/sudo << "EOF"
<code class="literal"># Begin /etc/pam.d/sudo

# include the default auth settings
auth include system-auth

# include the default account settings
account include system-account

# Set default environment variables for the service user
session required pam_env.so

# include system session defaults
session include system-session

# End /etc/pam.d/sudo</code>
EOF
chmod 644 /etc/pam.d/sudo
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
