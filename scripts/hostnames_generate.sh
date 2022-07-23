#!/bin/bash

echo "${0} is started"

set -o errexit

rm "$SETUP_ARENA_HOSTNAMES_TEMP"  || true
touch "$SETUP_ARENA_HOSTNAMES_TEMP"
sleep 2
# shellcheck disable=SC2013
for ip in $(cat $SETUP_ARENA_NODES_LIST); do
  echo "set $ip"
  echo $(ssh -i $SETUP_ARENA_KEYFILE $SETUP_ARENA_USERNAME@$ip "echo -n ${ip}' '; hostname -f") >> $SETUP_ARENA_HOSTNAMES_TEMP

#  echo "$(echo -n ${ip}' '; hostname -f)" >> $SETUP_ARENA_HOSTNAMES_TEMP
done

echo "$SETUP_ARENA_HOSTNAMES_TEMP :"
cat "$SETUP_ARENA_HOSTNAMES_TEMP"

echo "${0} is finished"
