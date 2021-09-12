#brew ls --versions wget || brew install wget
#brew ls --versions gnu-sed || brew install gnu-sed


rm $SETUP_ARENA_HOSTNAMES_TEMP
touch $SETUP_ARENA_HOSTNAMES_TEMP
sleep 2
# shellcheck disable=SC2013
for ip in $(cat $SETUP_ARENA_NODES_LIST); do
  echo ''
  echo 'delete '$ip' from known hosts'
  gsed -i '/'$ip'/d' ~/.ssh/known_hosts
  echo 'reading hostname line from '$ip
  echo $(ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$ip "echo -n ${ip}' '; hostname -f")
  echo $(ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$ip "echo -n ${ip}' '; hostname -f") >> $SETUP_ARENA_HOSTNAMES_TEMP
done

./scripts/setup_hostnames.sh

rm $SETUP_ARENA_HOSTNAMES_TEMP

ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$NAME_NODE 'bash -s' < ./scripts/install-adcm.sh
#
scp -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_BUNDLE_LINKS $SETUP_ARENA_USERNAME@$NAME_NODE:~/
ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$NAME_NODE 'bash -s' < ./scripts/adcm_load_bundles.sh

ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$NAME_NODE 'bash -s' < ./scripts/adcm_create_clusters.sh

ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$NAME_NODE 'bash -s' < ./scripts/adcm_create_hostproviders.sh

scp -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_NODES_LIST $SETUP_ARENA_USERNAME@$NAME_NODE:~/
ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa $SETUP_ARENA_USERNAME@$NAME_NODE 'bash -s' < ./scripts/adcm_create_hosts.sh
