#!/bin/bash
#run a command below
#docker buildx create --name multi-arch --platform linux/amd64,linux/arm64 && docker buildx use multi-arch

ARCH=(arm64 amd64)
ADDR="192.168.10.40"
PORT="5050"
KEY_FILE="./key"
#KEY_FILE="/Volumes/chia/keys/key"

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
	--push \
	.
	#-t ${ADDR}:${PORT}/chia:latest . --push
#docker push ${ADDR}:${PORT}/chia:latest
