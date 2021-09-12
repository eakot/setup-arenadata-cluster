#!/bin/bash
set -o errexit

source ./conf/env.sh

./scripts/hostnames_generate.sh

./scripts/hostnames_setup.sh

./scripts/install_adcm.sh

./scripts/adcm_load_bundles.sh

./scripts/adcm_create_clusters.sh

./scripts/adcm_create_hostproviders.sh

./scripts/adcm_create_hosts.sh
