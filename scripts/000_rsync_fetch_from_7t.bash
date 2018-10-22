#!/usr/bin/env bash

# default to run as lncd
#if [ $(whoami) != "lncd" ]; then
#   sudo su lncd -c $0
#   exit
#fi

[ $# -eq 0 ] && echo "sync done from cron on 7tshim!; $0 goforit # to run anyway" >&2 && exit 0
shift;
passfile=$(cd $(dirname $0);pwd)/mesonpass
[ ! -s $passfile ] && echo "need $passfile to have meson password!" && exit 1
sshpass -f $passfile rsync  --size-only -rzhi 7t:/twix/7t/*FF{,.tar} /Volumes/Hera/Raw/MRprojects/Other/
find /Volumes/Hera/Raw/MRprojects/Other/ -maxdepth 1 -type d -user $(id -u) -mmin -100 | xargs -r chmod -R g+w 
