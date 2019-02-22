#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

# find raw dicom list dirs
#   like '*DCM*' (usually ALLDCM) 
#   should have more than 300 files (slow to determine!)
# save to inputdirs.txt

cd $(dirname $0)
# 20180316FF/20180316FFDCMALL
# 20180720FF/20180720FF
#for d in /Volumes/Hera/Raw/MRprojects/Other/*{FF,FF[0-9]}/*DCM*/; do 
find /Volumes/Hera/Raw/MRprojects/Other/FF/*{FF,FF[0-9]}/ -maxdepth 1 -type d \( -iname '*DCM*' -or -iname '*FF*' \)|
 while read d; do 
   # skip if too few (might have a dicom mprage only directory)
   needatleast=1000
   n=$(find $d -maxdepth 1 -mindepth 1 -iname '*IMA' |sed ${needatleast}q|wc -l)
   [ $n -ne ${needatleast} ] && echo "# skipping $d, too few dicoms ($n<$needatleast)" >&2 && continue

   dcmexmpl=$(find $d -maxdepth 1 -mindepth 1 -iname '*IMA' -print -quit) 
   id=$(dicom_hinfo -no_name -tag 0010,0010 $dcmexmpl)
   [ -z "$id" ] && continue
   echo -e "$d\t$id\tsub-${id}"

done | tee txt/inputdirs.txt
