#!/bin/bash

set -e
set +h

USERNAME="$1"
SCRIPT="$2"

alps selfupdate
alps updatescripts
su - $USERNAME -c "$SCRIPT"
