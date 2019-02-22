#!/usr/bin/env bash

export SUBJECTS_DIR=/Volumes/Hera/preproc/7TFF_rest/FS

for t1 in /Volumes/Hera/Raw/BIDS/7TFF/sub-*/1/anat/sub-*_T1w.nii.gz; do
   [[ ! $t1 =~ sub-([^/]+FF) ]] && echo "bad name? $t1" && continue
   recon-all -s ${BASH_REMATCH[1]} -i $t1 -all &# -no-wsgcaatlas
   i=0
   while [ $(jobs -p |wc -l) -gt 10 ]; do
      let ++i
      echo "[$(date)] sleeping 100 for $i th time (last was $t1)"
      sleep 100
   done

done
