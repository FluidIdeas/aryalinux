#!/bin/bash

set -e

. /sources/build-properties

# Compiling a Cross-Toolchain
for script in /sources/cross-toolchain/*.sh
do

bash $script

done

# Cross Compiling Temporary Tools
for script in /sources/temp-tools/*.sh
do

bash $script

done
