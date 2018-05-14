#!/bin/bash

set -e

. /sources/build-properties

for script in /sources/toolchain/*.sh
do

bash $script

done

