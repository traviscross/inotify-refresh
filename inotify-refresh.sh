#!/bin/bash
##### -*- mode:shell-script; indent-tabs-mode:nil; sh-basic-offset:2 -*-
##### Author: Travis Cross <tc@traviscross.com>

browser="Chromium"
tab_title=""
ht_path=""

usage() {
  echo "$0 <tab title> <path>">&1
  exit 1
}

if [ "$#" -lt 2 ]; then usage; fi
tab_title="$1"
ht_path="$2"

last=$(date +%s)
inotifywait -m -r --exclude '.#.*' \
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
