#!/bin/bash

set -e
set +h

USERNAME="$1"
PACKAGE="$2"

make-ca -g -f

su - $USERNAME -c "alps -ni install $PACKAGE"
if [ ! -f "/var/lib/alps/installed/${PACKAGE}.json" ]
then
	echo "Application installation incomplete ($PACKAGE). Aborting..."
	exit 1
fi
