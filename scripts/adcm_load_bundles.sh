#!/bin/bash


set -o errexit
# https://docs.arenadata.io/adcm/sdk/bundle.html

echo "${0} is started"

SETUP_ARENA_BUNDLE_LINKS=./conf/bundle_links

token_answer=$(curl -d "username=admin&password=admin" -X POST localhost:8000/api/v1/token/)
token=$(echo $token_answer | jq -r '.token')
echo 'token = '$token

for bundle_link in $(cat $SETUP_ARENA_BUNDLE_LINKS); do
  echo "download $bundle_link"
  wget --no-check-certificate -nc  -P /opt/adcm/download "$bundle_link"
  filename="${bundle_link##*/}"
  echo "load bundle $filename to adcm"
  curl -sS -H "Authorization: Token ${token}" -X POST -F bundle_file=$filename localhost:8000/api/v1/stack/load/
done

echo "Accepting all bundle licences..."
bundles_json=$(curl -H "Authorization: Token ${token}" localhost:8000/api/v1/stack/bundle/ | jq '[.[] | {id, name}]')
for row in $(echo "${bundles_json}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  bundle_id=$(_jq '.id')
  echo "accept licence for bundle_id=${bundle_id}"
  curl -sS --fail -H "Authorization: Token ${token}" -X PUT "localhost:8000/api/v1/stack/bundle/${bundle_id}/license/accept/" | jq "."
done

echo "${0} is finished"

