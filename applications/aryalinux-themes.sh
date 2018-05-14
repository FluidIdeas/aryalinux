#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-themes"
DESCRIPTION="GTK+ themes for AryaLinux XFCE and Mate Desktop Environments"
VERSION="2016.11"

#REQ:greybird-gtk-theme
#REQ:breeze-gtk-theme
#REQ:arc-gtk-theme

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
