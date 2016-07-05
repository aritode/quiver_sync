#!/bin/bash -e
# Sync Quiver Notes Library with remote server and convert notes to HTML
###############################################################################
set -e          # exit on command errors (so you MUST handle exit codes properly!)
set -E          # pass trap handlers down to subshells
set -o pipefail # capture fail exit codes in piped commands
#set -x         # execution tracing debug messages

# Error handler
on_err() {
	echo ">> ERROR: $?"
	FN=0
	for LN in "${BASH_LINENO[@]}"; do
		[ "${FUNCNAME[$FN]}" = "main" ] && break
		echo ">> ${BASH_SOURCE[$FN]} $LN ${FUNCNAME[$FN]}"
		FN=$(( FN + 1 ))
	done
}
trap on_err ERR

QUIVERLIB_LOC="/Users/tpaulus/Google Drive/Apps/Quiver/Quiver.qvlibrary"
SERVER="lorien"
SRV_DEST="/srv/notes/"

rsync --partial --del -az -q "$QUIVERLIB_LOC" $SERVER:"$SRV_DEST"
ssh $SERVER 'quiver2html '$SRV_DEST'Quiver.qvlibrary/* -o '$SRV_DEST'Notebooks/'
