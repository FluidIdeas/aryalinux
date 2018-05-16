#!/bin/bash

set -e
set +h

USERNAME="$1"

alps selfupdate
alps updatescripts
su - $USERNAME -c "PKG_BUILDER=$1 alps install --options n --packages profile nano openssl general_which wget cacerts python2 python3 ntfs-3g fuse lvm2 parted gptfdisk shadow"
if ! grep "shadow=" /etc/alps/installed-list &> /dev/null
then
	echo "Essentials incomplete (shadow). Aborting..."
	exit 1
fi
PKG_BUILDER=$1 alps install-no-prompt sudo
if ! grep "sudo=" /etc/alps/installed-list &> /dev/null
then
        echo "Essentials incomplete (sudo). Aborting..."
        exit 1
fi
su - $USERNAME -c "PKG_BUILDER=$1 alps install --options n --packages usbutils pciutils openssh gobject-introspection libxml2 desktop-file-utils shared-mime-info ccache"
if ! grep "ccache=" /etc/alps/installed-list &> /dev/null
then
        echo "Essentials incomplete (ccache). Aborting..."
        exit 1
fi

