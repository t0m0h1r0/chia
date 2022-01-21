FROM ubuntu:hirsute AS builder
USER root
ARG chia_ver=main
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y bash python3 ca-certificates git openssl wget build-essential python3-dev python3-venv python3-distutils nfs-common apt lsb-release sudo systemctl libsodium-dev libgmp3-dev cmake g++ bc
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

WORKDIR /
RUN git clone https://github.com/Chia-Network/chia-blockchain.git
WORKDIR /chia-blockchain
#RUN git checkout 89f7a4b3d6329493cd2b4bc5f346a819c99d3e7b
RUN git submodule update --init
RUN sh install.sh

WORKDIR /
RUN git clone https://github.com/madMAx43v3r/chia-plotter.git
WORKDIR /chia-plotter
#RUN git checkout pool-puzzles
RUN git submodule update --init
RUN ./make_devel.sh
RUN ./build/chia_plot --help

####################
FROM ubuntu:hirsute
USER root
EXPOSE 8444
EXPOSE 8447
EXPOSE 8555

ARG DEBIAN_FRONTEND=noninteractive
ARG chia_ver=main
RUN apt update
RUN apt install -y bash python3 ca-certificates git openssl python3-venv python3-distutils apt lsb-release sudo systemctl bc libsodium23 apt-utils

COPY --from=builder /chia-blockchain /chia-blockchain
COPY --from=builder /chia-plotter/build/chia_plot /chia-blockchain/venv/bin/
RUN mkdir /plots && mkdir /work

#select master, harvester, or plotter
ENV mode "master"
ENV farmer_address "127.0.0.1"
ENV farmer_port "8447"
ENV farmer_key "999f6d391272a23cae8d4ce2589ce88931d28de9dc99e1d900fbbb7a4c78b3c2671996747a5e8134227c9485a81a8f41"
ENV pool_key "b526b72cb7841a757d919b8d7d412643ccfbf7de3b8eee50a27ba2cc62f21b37aafc49fa2a225b92dbb975564ea1945e"
ENV singleton_address "xch1f5memdx20fgklfk88war6npaeapyhn5keg4kahsd2xfwtufx2hcsaaghdl"
ENV loop=1
ENV thread=2
ENV testnet=false
ENV update=false
ENV tmp_dir=/work
ENV ram_dir=/ram
ENV ca_dir=/run/secrets/
ENV key_file=/run/secrets/chiakey
ENV plots_dir "/plots"
ENV chia "chia"
ENV conf_dir ".chia"

WORKDIR /chia-blockchain
ADD ./entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
