#!/bin/bash
##### -*- mode:shell-script; indent-tabs-mode:nil; sh-basic-offset:2 -*-
##### Author: Travis Cross <tc@traviscross.com>

browser="Chromium"
tab_title=""
ht_path=""

usage() {
  echo "usage: $0 [-b <browser title>] [-t <tab title>] <path>">&1
  exit 1
}

while getopts 'b:dht:' o "$@"; do
  case "$o" in
    b) browser="$OPTARG";;
    d) set -vx;;
    h) usage;;
    t) tab_title="$OPTARG";;
  esac
done
shift $(($OPTIND-1))

if [ "$#" -lt 1 ]; then usage; fi
ht_path="$1"

last=$(date +%s)
inotifywait -m -r \
  --exclude '/\.git/|/\.#' \
  --format '%e: %w%f' \
  -e 'modify,moved_to,moved_from,move,create,delete' \
  "$ht_path" \
  | while read l; do
  echo "$l" >&1
  now=$(date +%s)
  if test $((now > last+1)) -eq 1; then
    last=$now
    br=$(xdotool search --onlyvisible --name "${tab_title}.*${browser}$" | tail -n1)
    if [ -n "$br" ]; then
      echo "refreshing...">&1
      xdotool key --clearmodifiers --window $br 'F5'
    fi
  fi
done
