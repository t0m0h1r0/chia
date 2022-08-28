#!/bin/bash
#run a command below

ARCH=(amd64)
ADDR="reg1"
PORT="5000"
KEY_FILE="./key"
TIME=`date "+%Y%m%d%H%M%S"`

docker build \
	--build-arg chia_ver="${1:-latest}" \
	-t ${ADDR}:${PORT}/chia:${1:-latest} \
	-t ${ADDR}:${PORT}/chia:latest \
	-t ${ADDR}:${PORT}/chia:${TIME} \
	.
	#-t ${ADDR}:${PORT}/chia:latest . --push
docker push ${ADDR}:${PORT}/chia:latest
