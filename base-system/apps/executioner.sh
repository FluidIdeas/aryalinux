#!/bin/bash

set -e
set +h

USERNAME="$1"
SCRIPT="$2"

make-ca -g -f

su - $USERNAME -c "$SCRIPT"
