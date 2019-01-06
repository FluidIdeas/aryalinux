#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cracklib
#REC:linux-pam

cd $SOURCE_DIR

wget -nc https://github.com/libpwquality/libpwquality/releases/download/libpwquality-1.4.0/libpwquality-1.4.0.tar.bz2

NAME=libpwquality
VERSION=1.4.0.
URL=https://github.com/libpwquality/libpwquality/releases/download/libpwquality-1.4.0/libpwquality-1.4.0.tar.bz2

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

./configure --prefix=/usr --disable-static \
            --with-securedir=/lib/security &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mv /etc/pam.d/system-password{,.orig} &&
cat > /etc/pam.d/system-password << "EOF"
<code class="literal"># Begin /etc/pam.d/system-password # check new passwords for strength (man pam_pwquality) password required pam_pwquality.so authtok_type=UNIX retry=1 difok=1 \ minlen=8 dcredit=0 ucredit=0 \ lcredit=0 ocredit=0 minclass=1 \ maxrepeat=0 maxsequence=0 \ maxclassrepeat=0 geoscheck=0 \ dictcheck=1 usercheck=1 \ enforcing=1 badwords="" \ dictpath=/lib/cracklib/pw_dict # use sha512 hash for encryption, use shadow, and use the # authentication token (chosen password) set by pam_pwquality # above (or any previous modules) password required pam_unix.so sha512 shadow use_authtok # End /etc/pam.d/system-password</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
