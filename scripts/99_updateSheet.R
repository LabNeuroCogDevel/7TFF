#!/usr/bin/env Rscript

#
# update google sheet with what we've done
#

# devtools::install_github("tidyverse/googlesheets4")
# install.packages('googledrive')
library("googlesheets4")
library("googledrive")

ctime <- function(x) ifelse(file.exists(x), as.character(file.info(x)$ctime), NA)
nfiles <- function(x) sapply(x, function(g) length(Sys.glob(g)))

r <- sheets_get("1e2_pYZ3hRSXJJhW2HUVG2kZyfUQRLZVbmtS7H-pqkd4")
d <- googlesheets4::read_sheet(r$spreadsheet_id)


d$have_raw <- ctime(file.path("/Volumes/Hera/Raw/MRprojects/Other", d$MRID))
d$made_folder <- ctime(file.path("/Volumes/Hera/Projects/Collab/7TFF/raw", d$MRID))
d$made_bids <- ctime(paste0("/Volumes/Hera/Projects/Collab/7TFF/BIDS/sub-", d$MRID))
d$n_bids_nii <- nfiles(sprintf("/Volumes/Hera/Projects/Collab/7TFF/BIDS/sub-%s/1/*/*.nii.gz", d$MRID))
d$final_rest_preproc <- ctime(file.path("/Volumes/Hera/preproc/7TFF_rest/MHRest_nost_ica/", d$MRID, "brnaswdkm_func_4.nii.gz"))

# reupload -- clears any google sheet specificness (e.g. limited number of row, or columns, datavalidations)
write.csv(d, "status.csv", row.names=F)
up <- drive_update(as_id(r$spreadsheet_id), "status.csv")
