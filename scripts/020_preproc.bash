#!/usr/bin/env bash
set -e
source $HOME/.bashrc
set -uo pipefail
#
# preprocess as lncd
#

if [ $(whoami) != lncd ]; then
   sudo -u lncd $0
   exit
fi
/opt/ni_tools/preproc_pipelines/pp 7TFF_rest MHRest_nost_ica
