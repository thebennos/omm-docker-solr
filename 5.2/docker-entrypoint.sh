#!/bin/bash
set -e

trap 'echo "Shutting down..."; exit 0' SIGINT

if [ -z "$1" ]; then
  exec bin/solr start -f -m $SOLR_MEM_SIZE
  sleep 10
  exec /opt/solr/bin/solr create -c core1 -d /opt/solr/server/solr/core1
elif [[ "${1:0:1}" == '-' ]]; then
  exec bin/solr start -f "$@"
  for ((i=10;i--;i>0)); do
    LOG="$(find ./ -name "solr.log" -mtime -1)"
    if [ -n "$LOG" ]; then
      tail -f $LOG
    else
      echo "waiting for log for example \"$2\" to become available.."
      echo "${i} seconds remaining.."
    fi
    sleep 1
  done
else
  exec "$@"
fi


echo "fin."