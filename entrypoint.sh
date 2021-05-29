#!/bin/bash
sleeptime=10

cd /chia-blockchain
. activate
sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml
if ${verbose}; then
  sed -i 's/log_stdout: false/log_stdout: true/g' ~/.chia/mainnet/config/config.yaml
fi

if [[ -n ${plots_dir} ]];then
  chia plots add -d ${plots_dir}
fi
chia configure --log-level INFO
sleep ${delay}

if [ ${mode} = "master" ];then
  sed -i "s/xxx.xxx.xxx.xxx/${farmer_address}/g" /etc/vsftpd.conf
  systemctl start vsftpd
  trap 'chia stop farmer' TERM INT STOP ERR
  chia start farmer
  while true;do sleep ${sleeptime};done

elif [ ${mode} = "harvester" ];then
  sh get_ca.sh
  chia init --create-certs ${certs_dir}
  chia configure --set-farmer-peer ${farmer_address}:${farmer_port}
  trap 'chia stop harvester' TERM INT STOP ERR
  chia start harvester
  while true;do sleep ${sleeptime};done

elif [ ${mode} = "plotter" ];then
  trap 'rm -rf ${work_dir}' TERM INT STOP ERR
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  rm -rf ${work_dir}/*
  chia plots create -f ${farmer_key} -p ${pool_key} -t ${work_dir} -d ${plots_dir} -k 32 -n ${loop} -b 4500 -r 4
  rm -rf ${work_dir}

else
  echo "No Job"
fi
