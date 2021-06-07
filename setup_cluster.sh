#!/bin/bash

#ssh root@192.168.10.40 "docker volume create chia_plots -o device=/srv/dev-disk-by-uuid-0c84cc82-b2fa-40f8-8d48-237032b6b48f/chia/plots -o type=none -o o=bind"
#ssh root@192.168.10.50 "docker volume create chia_plots -o device=~/chia/plots -o type=none -o o=bind"
#ssh admin@192.168.10.100 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create chia_plots -o device=/share/chia/plots -o type=none -o o=bind"
#ssh admin@192.168.10.101 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create chia_plots -o device=/share/chia/plots -o type=none -o o=bind"
#ssh root@192.168.10.102 "docker volume create chia_plots -o device=/VOL/chia/plots -o type=none -o o=bind"

ssh root@192.168.10.40 "docker volume create docker_dir -o device=/var/lib/docker/ -o type=none -o o=bind"
ssh root@192.168.10.50 "docker volume create docker_dir -o device=/var/lib/docker/ -o type=none -o o=bind"
ssh admin@192.168.10.100 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create docker_dir -o device=/share/CACHEDEV1_DATA/.qpkg/container-station/var/lib/docker/ -o type=none -o o=bind"
ssh admin@192.168.10.101 "/share/CACHEDEV1_DATA/.qpkg/container-station/bin/docker volume create docker_dir -o device=/share/CACHEDEV1_DATA/.qpkg/container-station/var/lib/docker/ -o type=none -o o=bind"
ssh root@192.168.10.102 "docker volume create docker_dir -o device=/apps/docker-cli-rnapp/ -o type=none -o o=bind"
