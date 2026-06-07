#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:git
#REQ:openssh

cd $SOURCE_DIR
NAME=gitserver
VERSION=0
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")


echo $USER > /tmp/currentuser

echo -n "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty " >> /home/git/.ssh/authorized_keys
cat <user-ssh-key> >> /home/git/.ssh/authorized_keys
git config --system init.defaultBranch trunk
cat > ~/.gitconfig <<EOF
[user]
        name = <users-name>
        email = <users-email-address>
EOF
mkdir myproject
cd myproject
git init --initial-branch=trunk
git remote add origin git@gitserver:/srv/git/project1.git
cat >README <<EOF
This is the README file
EOF
git add README
git commit -m 'Initial creation of README'
git push --set-upstream origin trunk
git push
git clone git@gitserver:/srv/git/project1.git
cd project1
vi README
git commit -am 'Fix for README file'
git push
ln -svf /srv/git/project1.git /home/git/
git clone git@gitserver:project1.git
git clone git://gitserver/project1.git
groupadd -g 58 git
useradd -c "git Owner" -d /home/git -m -g git -s /usr/bin/git-shell -u 58 git
sed -i '/^git:/s/^git:[^:]:/git:NP:/' /etc/shadow
echo "/usr/bin/git-shell" >> /etc/shells
cd /srv/git/project1.git
git init --bare
chown -R git:git .
touch /srv/git/project1.git/git-daemon-export-ok


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -o git -g git -dm0700 /home/git/.ssh
install -o git -g git -m0600 /dev/null /home/git/.ssh/authorized_keys
install -o git -g git -m755 -d /srv/git/project1.git
make install-git-daemon
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd