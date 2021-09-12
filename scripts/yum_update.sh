nodes_list_file=./nodes_list

# shellcheck disable=SC2013
for ip in $(cat $nodes_list_file); do
  echo ''
  echo 'delete '$ip' from known hosts'
  gsed -i '/'$ip'/d' /Users/kotelnikov/.ssh/known_hosts


  ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa centos@$ip "sudo yum install epel-release -y && sudo yum update -y"
  ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa centos@$ip "sudo yum install -y wget, htop"

done