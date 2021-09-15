#!/bin/bash


token_answer=$(curl -d "username=admin&password=admin" -X POST localhost:8000/api/v1/token/)
token=$(echo $token_answer | jq -r '.token')
echo 'token = '$token

curl -H "Authorization: Token ${token}" localhost:8000/api/v1/provider/ | jq '.'

providers_json=$(curl -H "Authorization: Token ${token}" localhost:8000/api/v1/provider/ | jq '[.[] | {id, name}]')
echo "providers_json: ${providers_json}"

for row in $(echo "${providers_json}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  provider_id=$(_jq '.id')
  for host in $(cat $SETUP_ARENA_NODES_LIST); do
  echo "provider_id=${provider_id} -F host=${host}"
  curl -H "Authorization: Token ${token}" -X POST -F prototype_id="${provider_id}" -F fqdn="${host}" localhost:8000/api/v1/provider/${provider_id}/host/
  done
done