#!/bin/bash



token_answer=$(curl -d "username=admin&password=admin" -X POST localhost:8000/api/v1/token/)
token=$(echo $token_answer | jq -r '.token')
echo 'token = '$token

prototypes_json=$(curl -H "Authorization: Token ${token}" localhost:8000/api/v1/stack/cluster/ | jq '[.[] | {id, name}]')

curl -H "Authorization: Token ${token}" localhost:8000/api/v1/stack/cluster/ | jq '.'

for row in $(echo "${prototypes_json}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  id=$(_jq '.id')
  name=$(_jq '.name')
  echo "prototype_id=${bundle_id} -F name=${name}"
  curl -H "Authorization: Token ${token}" -X POST -F prototype_id=$id -F name="${name}_cluster" localhost:8000/api/v1/cluster/
done
