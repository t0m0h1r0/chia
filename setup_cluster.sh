#!/bin/bash

CHIA_PLOTS="chia_plots"
DOCER_DIR="docker_dir"
OPT="-o type=none -o o=bind"

ssh root@192.168.10.40 "docker volume create ${CHIA_PLOTS} -o device=/srv/dev-disk-by-uuid-0c84cc82-b2fa-40f8-8d48-237032b6b48f/chia/plots/ ${OPT}"
ssh root@192.168.10.50 "docker volume create ${CHIA_PLOTS} -o device=/root/chia/plots -o type=none -o o=bind"
ssh admin@192.168.10.100 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${CHIA_PLOTS} -o device=/share/chia/plots/ ${OPT}"
ssh admin@192.168.10.101 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${CHIA_PLOTS} -o device=/share/chia/plots/ ${OPT}"
ssh root@192.168.10.102 "docker volume create ${CHIA_PLOTS} -o device=/VOL/chia/plots/ ${OPT}"

ssh root@192.168.10.40 "docker volume create ${DOCER_DIR} -o device=/var/lib/docker/ ${OPT}"
ssh root@192.168.10.50 "docker volume create ${DOCER_DIR} -o device=/var/lib/docker/ ${OPT}"
ssh root@192.168.10.19 "docker volume create ${DOCER_DIR} -o device=/var/lib/docker/ ${OPT}"
#ssh admin@192.168.10.100 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${DOCER_DIR} -o device=/share/CACHEDEV1_DATA/Container/container-station-data/lib/docker/ ${OPT}"
#ssh admin@192.168.10.101 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${DOCER_DIR} -o device=/share/CACHEDEV1_DATA/Container/container-station-data/lib/docker/ ${OPT}"
ssh admin@192.168.10.100 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${DOCER_DIR} -o device=/var/lib/docker/ ${OPT}"
ssh admin@192.168.10.101 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create ${DOCER_DIR} -o device=/var/lib/docker/ ${OPT}"
ssh root@192.168.10.102 "docker volume create ${DOCER_DIR} -o device=/apps/docker-cli-rnapp/ ${OPT}"
