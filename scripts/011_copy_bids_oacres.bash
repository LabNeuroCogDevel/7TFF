#!/usr/bin/env bash

if [ $(whoami) != "lncd" ]; then
   sudo -u lncd $0
   exit
fi

cd $(dirname $0)
txdir=/Volumes/RAP_7T_MRI/BIDS/ 

# sudo mount //oacres3/physiodata/biomarkers/RAP_7T_MRI /Volumes/RAP_7T_MRI  -o domain=1UPMC-ACCT,username=foranw,gid=1000,noperm
! mount |grep RAP_7T_MRI -q && echo "missing RAP_7T_MRI" && exit 1
[ ! -r $txdir ] && mkdir $txdir
rsync -azvhLi ../BIDS/  $txdir --include='sub-*' --include='sub-*/**' --exclude='*'  --size-only
