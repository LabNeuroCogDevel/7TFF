#!/usr/bin/env bash

if [ $(whoami) != "lncd" ]; then
   sudo -u lncd $0
   exit
fi

cd $(dirname $0)
txdir=/Volumes/RAP_7T_MRI/raw/

# sudo mount //oacres3/rap/RAP/RAP_7T_MRI /Volumes/RAP_7T_MRI  -o domain=1UPMC-ACCT,username=foranw,gid=1000,noperm
#  previously sent to "biomarkers"
! mount |grep RAP_7T_MRI -q && echo "missing RAP_7T_MRI" && exit 1
[ ! -r $txdir ] && mkdir $txdir
rsync  -avhi --inplace --size-only /Volumes/Hera/Raw/MRprojects/Other/FF/  $txdir  \
   --include='*FF[1-9]' --include='*FF[1-9]/**' \
   --include='*FF' --include='*FF/**' \
   --exclude='*' 
