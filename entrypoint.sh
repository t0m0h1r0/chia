#!/bin/bash
sleep_time=10

cd /chia-blockchain
. activate

chia init
chia configure --log-level INFO
sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml
if ${verbose}; then
  sed -i 's/log_stdout: false/log_stdout: true/g' ~/.chia/mainnet/config/config.yaml
fi
if ${testnet}; then
  chia configure --testnet true
  chia configure --set-node-introducer testnet8-testnet8-introducer-0.chia.net:58445
fi
if [[ -n ${plots_dir} ]];then
  chia plots add -d ${plots_dir}
fi

if [ ${mode} = "master" ];then
  trap 'chia stop farmer' TERM INT STOP ERR
  chia init --create-certs ${ca_dir}
  chia keys add -f ${key_file}
  chia start farmer
  while true;do sleep ${sleep_time};done

elif [ ${mode} = "harvester" ];then
  chia init --create-certs ${ca_dir}
  chia configure --set-farmer-peer ${farmer_address}:${farmer_port}
  trap 'chia stop harvester' TERM INT STOP ERR
  chia start harvester
  while true;do sleep ${sleep_time};done

elif [ ${mode} = "plotter" ];then
  trap 'rm -rf ${work_dir}' TERM INT STOP ERR
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  rm -rf ${work_dir}/*
  chia plots create -f ${farmer_key} -p ${pool_key} -t ${work_dir} -d ${plots_dir} -n ${loop} -r ${thread} -k 32 -b 4500
  rm -rf ${work_dir}

elif [ ${mode} = "plotter-fast" ];then
  trap 'rm -rf ${work_dir}' TERM INT STOP ERR
  rm -rf ${tmp_dir}/*
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  rm -rf ${work_dir}/*
  /chia-plotter/build/chia_plot -f ${farmer_key} -p ${pool_key} -t ${work_dir}/ -d ${plots_dir}/ -n ${loop} -r ${thread}
  rm -rf ${work_dir}

else
  echo "No Job"
fi
