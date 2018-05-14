#!/bin/bash

set -e

. /sources/build-properties

for script in /sources/final-system/*
do
	bash $script
done
