#!/bin/bash

echo "${0} is started"

set -o errexit

sudo yum install epel-release -y
sudo yum update -y
sudo yum update -y glibc-common
sudo yum install -y glibc-langpack-en  || true

sudo yum install -y yum-utils docker device-mapper-persistent-data lvm2
sudo systemctl enable docker
sudo systemctl start docker

docker pull arenadata/adcm:2021.06.17.06
sudo docker rm adcm -f
sudo docker create --name adcm -p 8000:8000 -v /opt/adcm:/adcm/data docker.io/arenadata/adcm:2021.06.17.06
sudo docker start adcm

sudo -- su -c "yum install -y wget"
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo -- su -c "yum install -y jq"

timeout 30 bash -c 'while [[ "$(curl --insecure -s -o /dev/null -w ''%{http_code}'' -d "username=admin&password=admin" -X POST localhost:8000/api/v1/token/)" != "200" ]]; do echo "wait docker run (up to 5 min)..."; sleep 20; done'


echo "${0} is finished"
