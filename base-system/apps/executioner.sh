#!/bin/bash

set -e
set +h

USERNAME="$1"
SCRIPT="$2"

. "$(dirname "$0")/as-user.sh"

make-ca -g -f

as_user "$USERNAME" "$SCRIPT"
