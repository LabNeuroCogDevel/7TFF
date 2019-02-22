#!/usr/bin/env Rscript

# make niftis in BIDS dir format
# expect raw dicoms like rawlinks/subj_date/seqno_protcol_ndcm
# output nii.gz into sub-$id/1/{anat,func}/*.nii.gz

library(dplyr)
write_and_note <- function(f, cmd) {
   cat("checking", f, "\n")
   if (!file.exists(f)) {
      system(cmd)
      system(sprintf('3dNotes -h "%s" %s', cmd, f))
   }
}

dirlist <- append(Sys.glob("rawlinks/*FF/*/"), Sys.glob("rawlinks/*FF[1-9]/*/"))

info <-
   lapply( strsplit(dirlist, "[/_]"),
         function(x) {
            x <- as.list(x)
            names(x)<-c("raw", "id", "seqno", "protocol", "ndcm")
            as.data.frame(x)
         }) %>%
   bind_rows %>%
   mutate(indir=dirlist) %>%
   select(-raw)

# -- identify the things we want to keep
idxs <- list(
             #^MP2RAGE.*T1-Images
  t1 = grepl("^MP2RAGEPTX.TR6000.*.UNI.DEN$", info$protocol, perl=T) &
           info$ndcm %in% c(256, 192),
  rest= grepl("bold.*(REST|tacq2s-180).*", info$protocol) &
             info$ndcm == 10560
)

# -- apply assignments
info$process <- NA
# ugly `<<-`, reader beware -- code might burn your eyes
discard_setpreproc_type <-
  mapply(function(i, n) info$process[i] <<- n, idxs, names(idxs))


# --- setup file and directory names, and dcm2nii command to run
# like
#   {session}/anat/sub-{subject}_T1w
#   {session}/func/sub-{subject}_dir-{acq}_task-rest_run-{item:02d}_bold
#   {session}/func/sub-{subject}_task-mgs_run-{item:02d}_acq-{acq}_bold
proc <- info %>%
   filter(!is.na(process)) %>%
   group_by(id, process) %>%
   mutate(item=rank(as.numeric(seqno)),
          type=ifelse(process=="t1", "anat", "func"),
          name=sprintf("sub-%s_task-%s_run-%02d_bold", id, process, item),
          outdir=sprintf("sub-%s/%d/%s/", id, 1, type) )

# rename file for anat
t1idx <- proc$type=="anat"
proc$name[t1idx] <- gsub("_task.*", "_T1w", proc$name[t1idx])

# described expected final outputfile
proc$file <- sprintf("%s/%s.nii.gz", proc$outdir, proc$name)

# and the command to create it
proc$cmd <- sprintf("dcm2niix -o %s -f %s %s",
                    proc$outdir, proc$name, proc$indir)

#print.data.frame(proc, row.names=F)
proc %>% group_by(id) %>% tally() %>% print.data.frame(row.names=F)

# create directories and nifti files
discard_dir <-
  lapply(proc$outdir, function(x) dir.exists(x) || dir.create(x, recursive=T) )
discard_cmd <-
  mapply(function(f, cmd) write_and_note(f, cmd), proc$file, proc$cmd )
