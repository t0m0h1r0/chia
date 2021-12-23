#!/bin/bash
#run a command below

ARCH=(arm64 amd64)
ADDR="nuc1"
PORT="5050"
KEY_FILE="./key"
TIME=`date "+%Y%m%d%H%M%S"`

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create \
	--platform linux/amd64,linux/arm64 \
	--config buildkitd.toml \
	--driver docker-container --driver-opt image=moby/buildkit:master,network=host \
	--buildkitd-flags '--allow-insecure-entitlement security.insecure' \
	--use --name multi-arch
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--secret=id=chiakey,src=${KEY_FILE}  \
	--build-arg chia_ver="${1:-latest}" \
	-t ${ADDR}:${PORT}/chia:${1:-latest} \
	-t ${ADDR}:${PORT}/chia:latest \
	-t ${ADDR}:${PORT}/chia:${TIME} \
	--push \
	.
	#-t ${ADDR}:${PORT}/chia:latest . --push
#docker push ${ADDR}:${PORT}/chia:latest
