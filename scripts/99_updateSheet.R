#!/usr/bin/env Rscript

#
# update google sheet with what we've done
#

# source("https://install-github.me/r-lib/rematch2")
# devtools::install_github("tidyverse/googlesheets4")
# install.packages('googledrive')
library("googlesheets4")
library("googledrive")

ctime <- function(x) ifelse(file.exists(x), as.character(file.info(x)$ctime), NA)
nfiles <- function(x) sapply(x, function(g) length(Sys.glob(g)))
have_step <- function(f, msg) ifelse(as.numeric(nfiles(f))>0, msg, "")

r <- sheets_get("1e2_pYZ3hRSXJJhW2HUVG2kZyfUQRLZVbmtS7H-pqkd4")
d <- googlesheets4::read_sheet(r$spreadsheet_id)


d$have_raw <- ctime(file.path("/Volumes/Hera/Raw/MRprojects/Other/FF", d$MRID))
d$linked_protocols <- ctime(file.path("/Volumes/Hera/Projects/Collab/7TFF/BIDS/rawlinks/", d$MRID))
d$made_bids <- ctime(paste0("/Volumes/Hera/Projects/Collab/7TFF/BIDS/sub-", d$MRID))
d$n_bids_nii <- nfiles(sprintf("/Volumes/Hera/Projects/Collab/7TFF/BIDS/sub-%s/1/*/*.nii.gz", d$MRID))
d$final_rest_preproc <- ctime(file.path("/Volumes/Hera/preproc/7TFF_rest/MHRest_nost_ica/", d$MRID, "brnaswdkm_func_4.nii.gz"))
d$steps_copied <- paste(sep="_",
    have_step(file.path("/Volumes/RAP_7T_MRI/raw/", d$MRID, "*"), "raw"),
    have_step(sprintf("/Volumes/RAP_7T_MRI/BIDS/sub-%s/*/*", d$MRID), "bids"),
    have_step(file.path("/Volumes/RAP_7T_MRI/preproc/MHRest_nost_ica/", d$MRID, "brnaswdkm_func_4.nii.gz"), "preproc")
)


# reupload -- clears any google sheet specificness (e.g. limited number of row, or columns, datavalidations)
write.csv(d, "status.csv", row.names=F)
up <- drive_update(as_id(r$spreadsheet_id), "status.csv")
