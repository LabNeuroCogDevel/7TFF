# Scripting
see `scripts/runme.bash`

# Raw MR
/Volumes/Hera/Raw/MRprojects/Other
/Volumes/Hera/Raw/BIDS/7TFF

# log
## 20180611 -- fix bad mprage
```
 rm preproc/MHT1_2mm -r 
 rm preproc/MHRest_nost_ica/*/{.func2struct_complete,.mean_final_func_complete,.bandpass_filter_complete,.nuisance_*,.preprocessfunctional_complete,.rescaling_complete,.thresholding_complete,.warp_complete,*w{,d}km_*}
```
update and rerun `BIDS/020_mkBIDS.R`
rerun `scripts/011_copy_bids_oacres.bash`
rerun `scripts/020_preproc.bash`
