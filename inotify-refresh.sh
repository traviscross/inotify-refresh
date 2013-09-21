#!/bin/bash
##### -*- mode:shell-script; indent-tabs-mode:nil; sh-basic-offset:2 -*-
##### Author: Travis Cross <tc@traviscross.com>

browser="Chromium"
tab_title=""
ht_path=""
do_chown=false
owner=""
do_chmod=false
perms=""

usage() {
  echo "usage: $0 [-b <browser title>] [-o <owner[:group]>] [-p <perm mode>] [-t <tab title>] <path>">&1
  exit 1
}

while getopts 'b:dho:p:t:' o "$@"; do
  case "$o" in
    b) browser="$OPTARG";;
    d) set -vx;;
    h) usage;;
    o) do_chown=true; owner="$OPTARG";;
    p) do_chmod=true; perms="$OPTARG";;
    t) tab_title="$OPTARG";;
  esac
done
shift $(($OPTIND-1))

if [ "$#" -lt 1 ]; then usage; fi
ht_path="$1"

if $do_chown; then chown -R "$owner" $ht_path; fi
if $do_chmod; then chmod -R "$perms" $ht_path; fi

last=$(date +%s)
inotifywait -m -r \
  --exclude '/\.git/|/\.#|/#' \
  --format '%e %w%f' \
  -e 'modify,moved_to,moved_from,move,create,delete' \
  "$ht_path" \
  | while read -r ev fl; do
  echo "$ev $fl" >&1
  now=$(date +%s)
  if [ "$ev" != "DELETE" ]; then
    $do_chown && chown "$owner" "$fl"
    $do_chmod && chmod "$perms" "$fl"
  fi
  if test $((now > last+1)) -eq 1; then
    last=$now
    br=$(xdotool search --onlyvisible --name "${tab_title}.*${browser}$" | tail -n1)
    if [ -n "$br" ]; then
      echo "refreshing...">&1
      xdotool key --clearmodifiers --window $br 'F5'
    fi
  fi
done
