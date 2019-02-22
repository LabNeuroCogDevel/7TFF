#!/usr/bin/env bash

# 
# 20180912 - long overdue script to sync from usb 
#
[ ! -d /mnt/usb/Data/Ferrarelli ] && echo -e "no /mnt/usb/Data/Ferrarelli, consider:\n sudo mount /dev/sde2 /mnt/usb" && exit 1

# folders on 7t look like yyyymmddLuna with some number of digits after
# usually just yyyymmddLuna[12], but sometimes yyyymmddLuna-xxxxx (xxxx = lunaid)
rsync --size-only -avhi /mnt/usb/Data/Ferrarelli/*FF* /Volumes/Hera/Raw/MRprojects/Other/FF/ $@
