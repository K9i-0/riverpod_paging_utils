#!/bin/sh
set -eu
# Resolve the app from this script, independent of the caller's working directory.
cd "$(dirname "$0")/../example"
export PROJECT_ROOT="$PWD"
export SHOW_TERMINAL="${SHOW_TERMINAL:-false}"
exec dart run patrol_mcp "$@"
