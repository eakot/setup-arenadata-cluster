#!/bin/bash


token_answer=$(curl -d "username=admin&password=admin" -X POST localhost:8000/api/v1/token/)
token=$(echo $token_answer | jq -r '.token')
echo 'token = '$token


curl -H "Authorization: Token ${token}" localhost:8000/api/v1/stack/provider/ | jq '.'

providers_json=$(curl -H "Authorization: Token ${token}" localhost:8000/api/v1/stack/provider/ | jq '[.[] | {id, name}]')
echo "providers_json: ${providers_json}"
for row in $(echo "${providers_json}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  id=$(_jq '.id')
  name=$(_jq '.name')
  echo "prototype_id=${id} -F name=${name}"
  curl -H "Authorization: Token ${token}" -X POST -F prototype_id=$id -F name="${name}_provider" localhost:8000/api/v1/provider/
done