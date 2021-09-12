#!/bin/bash


for ip in $(cat $SETUP_ARENA_NODES_LIST); do
  echo "read $ip from known hosts"
done

HOSTNAMES=$(cat $SETUP_ARENA_HOSTNAMES_TEMP)
echo 'hostnames:'
echo $HOSTNAMES

# shellcheck disable=SC2013
for ip in $(cat $SETUP_ARENA_NODES_LIST); do
  echo ''
  echo 'setting hostnames in '$ip

  scp -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_HOSTNAMES_TEMP $SETUP_ARENA_USERNAME@$ip:~/
  ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$ip /bin/bash <<EOF
  echo "SETUP_ARENA_HOSTNAMES_TEMP: $SETUP_ARENA_HOSTNAMES_TEMP"

  echo "SETUP_ARENA_HOSTNAMES_TEMP:"
  cat $SETUP_ARENA_HOSTNAMES_TEMP

  echo "/etc/hosts:"
  cat /etc/hosts

  echo "grep -Fxvf /etc/hosts $SETUP_ARENA_HOSTNAMES_TEMP :"
  grep -Fxvf /etc/hosts $SETUP_ARENA_HOSTNAMES_TEMP

  sudo -- su -c "grep -Fxvf /etc/hosts $SETUP_ARENA_HOSTNAMES_TEMP >> /etc/hosts"
  cat /etc/hosts

#  sudo -- su -c "echo $new_hostnames >> /etc/hosts"; cat /etc/hosts
#  localhost_line="127.0.1.1 $(hostname -f)"
#  if ! grep '${localhost_line}' /etc/hosts > /dev/null; then
#    sudo -- su -c "echo '${localhost_line}' >> /etc/hosts"; cat /etc/hosts
#  fi
#
#  sudo systemctl restart systemd-hostnamed
#  sudo setenforce 0
EOF

done

rm $SETUP_ARENA_HOSTNAMES_TEMP

echo "${0} finished"
