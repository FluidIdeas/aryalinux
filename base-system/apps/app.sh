#!/bin/bash

set -e
set +h

USERNAME="$1"
PACKAGE="$2"

. "$(dirname "$0")/as-user.sh"

make-ca -g -f

as_user "$USERNAME" "alps -ni install $PACKAGE"
if [ ! -f "/var/lib/alps/installed/${PACKAGE}.json" ]
then
	echo "Application installation incomplete ($PACKAGE). Aborting..."
	exit 1
fi
