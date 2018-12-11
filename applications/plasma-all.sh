#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:GConf
#REQ:gtk2
#REQ:gtk3
#REQ:krameworks5
#REQ:libpwquality
#REQ:libxkbcommon
#REQ:mesa
#REQ:wayland
#REQ:networkmanager
#REQ:pulseaudio
#REQ:python2
#REQ:qca
#REQ:taglib
#REQ:xcb-util-cursor
#REC:libdbusmenu-qt
#REC:libcanberra
#REC:x7driver#libinput
#REC:linux-pam
#REC:lm_sensors
#REC:oxygen-icons5
#REC:pciutils
#OPT:glu
#OPT:ibus
#OPT:x7driver#xorg-synaptics-driver

cd $SOURCE_DIR


URL=""

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

url=http://download.kde.org/stable/plasma/5.13.4/
wget -r -nH -nd -A '*.xz' -np $url
cat > plasma-5.13.4.md5 << "EOF"
<code class="literal">2cfae8349d3c5a4d7b52269b6ef580bc kdecoration-5.13.4.tar.xz dfe4e097033f48d5f3b56d7d9fe91c91 libkscreen-5.13.4.tar.xz 939be7f1b81f8948d3026ea0f6b71332 libksysguard-5.13.4.tar.xz a5811405ebf81ced2d96dddda14dc65c breeze-5.13.4.tar.xz 544d7306a573a4b1af9cf15bea565f77 breeze-gtk-5.13.4.tar.xz 6f1846e0f49c0e660ffea7b25d979f5c kscreenlocker-5.13.4.tar.xz 431d2a2eea56e05659d4d9bfee75b8f9 oxygen-5.13.4.tar.xz 787f4cf0ebb6a296a907526f8a05d96e kinfocenter-5.13.4.tar.xz 38cdb99d3e7133dd8720073d184c0219 ksysguard-5.13.4.tar.xz 886af79baa7b478ee25ce9491f0398bd kwin-5.13.4.tar.xz 3035c264c2c00d274995216f135a2525 plasma-workspace-5.13.4.tar.xz 3f3de6be50ce252d5f000f200fd274c7 bluedevil-5.13.4.tar.xz a092d24dfd11b41c56a6babe7c8ec460 kde-gtk-config-5.13.4.tar.xz 9bcb6800aa2049b77dd0e31b1f48bd86 khotkeys-5.13.4.tar.xz f5a94fb11385cd4df4df330193ebb395 kmenuedit-5.13.4.tar.xz bf91e1d9eefc6660de6027aceeff6c97 kscreen-5.13.4.tar.xz e7f0bfb74c5d5a9ff43e6de6cb0f0d8d kwallet-pam-5.13.4.tar.xz 7f666f407e8f1e076897e68295c8f5a7 kwayland-integration-5.13.4.tar.xz 57638eed026c081df092baef0615eb92 kwrited-5.13.4.tar.xz 69ff78fc195af7e4994429b44454f3f9 milou-5.13.4.tar.xz 7c2bd25f90a7d55dc334897286facfc6 plasma-nm-5.13.4.tar.xz edef493711c1f8b7dde43390ff415eb4 plasma-pa-5.13.4.tar.xz 4ab6df9997269d2263c3e6fb2d6b4bf7 plasma-workspace-wallpapers-5.13.4.tar.xz 52deb7a41477d704a6895a7bdccaa1d7 polkit-kde-agent-1-5.13.4.tar.xz 728661126e6f4d414c5fa2a7d596ecbf powerdevil-5.13.4.tar.xz c1461af55b31cbf0473df4b30d90c376 plasma-desktop-5.13.4.tar.xz 35d28871e37fd28602066706967a9bb0 kdeplasma-addons-5.13.4.tar.xz 0b3cabd2f882599dffd5bd49b55a231e kgamma5-5.13.4.tar.xz 14e004c9d8112815b8bb0c6438a5d57f ksshaskpass-5.13.4.tar.xz #b97352709bd0ed4a7a8d3f28630b85a6 plasma-sdk-5.13.4.tar.xz 0c9af753ed311600b218747fa6eb5dcd sddm-kcm-5.13.4.tar.xz b101c424b5b13cecf32aab93c4215e15 user-manager-5.13.4.tar.xz e46195de68d3cabbb0b73e4252aaf95b discover-5.13.4.tar.xz #db28bc45387c0f4be49de795040df888 breeze-grub-5.13.4.tar.xz #85f27da438e5e6476220112e0728cdbe breeze-plymouth-5.13.4.tar.xz 4147607b008aefcc744eb19896a37f73 kactivitymanagerd-5.13.4.tar.xz a8ef5bd003ea74107d176d42ae0e83e9 plasma-integration-5.13.4.tar.xz 7e4a31d74ae071054d225bb8075647fd plasma-tests-5.13.4.tar.xz 0600243811dbda474d1c994de6973d3f plymouth-kcm-5.13.4.tar.xz 643c83817fcd3668eedfc01b60ab4731 xdg-desktop-portal-kde-5.13.4.tar.xz 147892484b3ba637840e47881b52434d drkonqi-5.13.4.tar.xz 52899d46e4fa6b293699d20163fa10d1 plasma-vault-5.13.4.tar.xz d6963e6b203d0bbc864f35a272370370 plasma-browser-integration-5.13.4.tar.xz 90f115ede33aef5582ac17bf2a95f324 kde-cli-tools-5.13.4.tar.xz 9672ac04c144af86dae18eeb47da01b9 systemsettings-5.13.4.tar.xz</code>
EOF
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
bash -e
while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    tar -xf $file
    pushd $packagedir

       mkdir build
       cd    build

       cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
             -DCMAKE_BUILD_TYPE=Release         \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&

        make
        as_root make install
    popd


    as_root rm -rf $packagedir
    as_root /sbin/ldconfig

done < plasma-5.13.4.md5

exit

cd /usr/share/xsessions/
[ -e plasma.desktop ] || as_root ln -sfv $KF5_PREFIX/share/xsessions/plasma.desktop

cd $KF5_PREFIX/share/plasma/plasmoids

for j in $(find -name \*.js); do
  as_root ln -sfv ../code/$(basename $j) $(dirname $j)/../ui/
done

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/pam.d/kde << "EOF" 
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF

cat > /etc/pam.d/kde-np << "EOF" 
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF

cat > /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat > ~/.xinitrc << "EOF"
<code class="literal">dbus-launch --exit-with-session $KF5_PREFIX/bin/startkde</code>
EOF

startx
startx &> ~/x-session-errors
sed '/^Name=/s/Plasma/Plasma on Xorg/' -i /usr/share/xsessions/plasma.desktop

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
