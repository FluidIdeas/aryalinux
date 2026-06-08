#!/bin/bash

set -e
set +h

USERNAME="$1"

make-ca -g -f

su - $USERNAME -c "alps -ni install bash-completion python3 nano which wget make-ca ntfs-3g fuse lvm2 parted gptfdisk shadow libpwquality"
if [ ! -f /var/lib/alps/installed/shadow.json ]
then
	echo "Essentials incomplete (shadow). Aborting..."
	exit 1
fi
alps -ni install sudo
if [ ! -f /var/lib/alps/installed/sudo.json ]
then
	echo "Essentials incomplete (sudo). Aborting..."
	exit 1
fi
su - $USERNAME -c "alps -ni install usbutils pciutils openssh glib2 gobject-introspection libxml2 desktop-file-utils shared-mime-info ccache"
if [ ! -f /var/lib/alps/installed/ccache.json ]
then
	echo "Essentials incomplete (ccache). Aborting..."
	exit 1
fi
