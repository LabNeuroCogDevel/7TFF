#!/usr/bin/env bash

#
# run all steps to get data
#

# should run as lncd
if [ $(id -u) -ne 1000 ]; then
   sudo -u lncd $0
   exit
fi
cd $(dirname $0)
#./000_rsync_fetch_from_7t.bash
./001_copy_raw_oacres.bash
./010_link_and_bids.bash
./011_copy_bids_oacres.bash
./020_preproc.bash
#./030_FS.bash
./99_updateSheet.R
