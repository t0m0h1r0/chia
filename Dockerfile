FROM ubuntu:hirsute
USER root

EXPOSE 8444
EXPOSE 8447
EXPOSE 8555

ARG DEBIAN_FRONTEND=noninteractive
ARG chia_ver=latest
RUN apt-get update && apt-get install -y bash python3 ca-certificates git openssl wget build-essential python3-dev python3-venv python3-distutils nfs-common apt lsb-release sudo vsftpd ftp systemctl

RUN --mount=type=secret,id=chiakey,dst=/key \
	git clone --branch ${chia_ver} https://github.com/Chia-Network/chia-blockchain.git && \
	cd chia-blockchain && \
	git submodule update --init mozilla-ca && \
	sed -i '/sudo apt-get install -y python3/d' install.sh && \
	sh install.sh && \
	echo done
RUN --mount=type=secret,id=chiakey,dst=/key \
	cd chia-blockchain && \
	. ./activate && \
	chia init && \
	chia keys add -f /key && \
	mkdir /plots && mkdir /work && mkdir /ca && \
	echo done

ENV keys ""
ENV certs_dir "/ca"
ENV plots_dir "/plots"
ENV verbose false

#select master, harvester, or plotter
ENV mode "master"
ENV farmer_address "127.0.0.1"
ENV farmer_port "8447"
ENV farmer_key "999f6d391272a23cae8d4ce2589ce88931d28de9dc99e1d900fbbb7a4c78b3c2671996747a5e8134227c9485a81a8f41"
ENV pool_key "b526b72cb7841a757d919b8d7d412643ccfbf7de3b8eee50a27ba2cc62f21b37aafc49fa2a225b92dbb975564ea1945e"
ENV loop=1
ENV tmp_dir=/work
ENV ftp_port "21"
ENV delay "0"

WORKDIR /chia-blockchain
ADD ./entrypoint.sh entrypoint.sh
ADD ./get_ca.sh get_ca.sh
ADD ./vsftpd.conf /etc/vsftpd.conf

ENTRYPOINT ["bash","./entrypoint.sh"]
