#!/usr/bin/env bash

cpu_percent=$(
  top -l 1 | awk -F'[:,%]' '/CPU usage/ {
    user=$2
    sys=$4
    gsub(/[^0-9.]/, "", user)
    gsub(/[^0-9.]/, "", sys)
    printf "%.0f", user + sys
  }'
)

mem_percent=$(
  memory_pressure | awk -F': ' '
    /System-wide memory free percentage/ {
      gsub(/%/, "", $2)
      printf "%d", 100 - $2
    }'
)

[ -z "$mem_percent" ] && mem_percent=0

cpu_graph=$(awk "BEGIN { printf \"%.2f\", $cpu_percent / 100 }")
mem_graph=$(awk "BEGIN { printf \"%.2f\", $mem_percent / 100 }")

sketchybar --push cpu_graph "$cpu_graph" \
           --set cpu_graph label="${cpu_percent}%"

sketchybar --push mem_graph "$mem_graph" \
           --set mem_graph label="${mem_percent}%"
