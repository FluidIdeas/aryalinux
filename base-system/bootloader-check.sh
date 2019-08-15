#!/bin/bash

set -e

. ./build-properties

type=$(sudo fdisk -l $DEV_NAME | grep "Disklabel type" | tr -s ' ' | rev | cut -d ' ' -f1 | rev)

status=0

if [ -d /sys/lib/firmware ] && [ $type == "msdos" ]; then
  status=1
fi

if [ $type == "gpt" ]; then
  efipart=$(sudo fdisk -l $DEV_NAME | grep "EFI System" | tr -s ' ' | cut -d ' ' -f1)
  if [ "x$efipart" == "x" ]; then
    if [ "x$status" == "x" ]; then
      status=2
    else
      status=3
    fi
  fi
fi

if [ $status == "1" ]; then
  echo "Would not install bootloader. Partition type msdos. Please reboot in legacy mode"
fi

if [ $status == "2" ]; then
  echo "Would not install bootloader. Partition type gpt but not EFI partition defined."
fi

if [ $status == "3" ]; then
  echo "Would not install bootloader. Partition type msdos. Please reboot in legacy mode"
  echo "Would not install bootloader. Partition type gpt but not EFI partition defined."
fi

if [ $status != "0" ]; then
  exit 1
else
  exit 0
fi