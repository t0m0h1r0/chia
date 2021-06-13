FROM ubuntu:hirsute
USER root

EXPOSE 8444
EXPOSE 8447
EXPOSE 8555

ARG DEBIAN_FRONTEND=noninteractive
ARG chia_ver=latest
RUN apt-get update && apt-get install -y bash python3 ca-certificates git openssl wget build-essential python3-dev python3-venv python3-distutils nfs-common apt lsb-release sudo systemctl libsodium-dev libgmp3-dev cmake g++ git

RUN git clone --branch ${chia_ver} https://github.com/Chia-Network/chia-blockchain.git && \
	cd chia-blockchain && \
	git submodule update --init mozilla-ca && \
	sed -i '/sudo apt-get install -y python3/d' install.sh && \
	sh install.sh && \
	echo done
RUN git clone https://github.com/madMAx43v3r/chia-plotter.git && \
	cd chia-plotter && \
	git submodule update --init && \
	./make_devel.sh && \
	./build/chia_plot --help && \
	echo done
RUN cd chia-blockchain && \
	mkdir /plots && mkdir /work && \
	echo done

#select master, harvester, or plotter
ENV mode "master"
ENV farmer_address "127.0.0.1"
ENV farmer_port "8447"
ENV farmer_key "999f6d391272a23cae8d4ce2589ce88931d28de9dc99e1d900fbbb7a4c78b3c2671996747a5e8134227c9485a81a8f41"
ENV pool_key "b526b72cb7841a757d919b8d7d412643ccfbf7de3b8eee50a27ba2cc62f21b37aafc49fa2a225b92dbb975564ea1945e"
ENV loop=1
ENV thread=2
ENV testnet=false
ENV tmp_dir=/work
ENV ca_dir=/run/secrets/
ENV key_file=/run/secrets/chiakey
ENV plots_dir "/plots"

WORKDIR /chia-blockchain
ADD ./entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
