#!/bin/bash

rm $SETUP_ARENA_HOSTNAMES_TEMP
touch $SETUP_ARENA_HOSTNAMES_TEMP
sleep 2
# shellcheck disable=SC2013
for ip in $(cat $SETUP_ARENA_NODES_LIST); do
  echo ''
  echo "$(echo -n ${ip}' '; hostname -f)" >> $SETUP_ARENA_HOSTNAMES_TEMP
  echo $(ssh -o StrictHostKeyChecking=accept-new -i $SETUP_ARENA_KEYFILE $SETUP_ARENA_USERNAME@$ip "echo -n ${ip}' '; hostname -f") >> $SETUP_ARENA_HOSTNAMES_TEMP

#  echo "$(echo -n ${ip}' '; hostname -f)" >> $SETUP_ARENA_HOSTNAMES_TEMP
done
