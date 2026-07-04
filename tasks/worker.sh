#!/bin/sh
# Worker wrapper for the parallel e2e runner (Linux/macOS).
# Isolates the 1C platform cache/temp per worker so concurrent 1C/ibcmd
# processes on one machine do not contend on shared platform files.
#   $1 - isolated env dir   $2 - test file   $3 - junit report   $4 - log file
export TMPDIR="$1"
export TEMP="$1"
export TMP="$1"
export HOME="$1"
oneunit execute -f "$2" --junit "$3" --mode flat > "$4" 2>&1
