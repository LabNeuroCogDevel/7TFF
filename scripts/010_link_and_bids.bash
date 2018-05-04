#!/usr/bin/env bash

# take the large signle dicom (IMA) file and give a per protocol folder
# parse those folders for stuff we care about and give it a BIDS like strucutre
# -- BIDS will be used by preprocess scripts
cd /Volumes/Hera/Raw/BIDS/7TFF/
./010_gen_raw_links.bash
./020_mkBIDS.R

