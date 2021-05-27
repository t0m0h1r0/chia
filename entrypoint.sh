#!/bin/bash

cd /chia-blockchain
. activate
sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml
if [[ -n ${plots_dir} ]];then
  chia plots add -d ${plots_dir}
fi
chia configure --log-level INFO
sleep ${delay}

if [ ${mode} = "master" ];then
  sed -i "s/xxx.xxx.xxx.xxx/${farmer_address}/g" /etc/vsftpd.conf
  systemctl start vsftpd
  trap 'chia stop farmer' TERM
  chia start farmer
  if ${verbose}; then
    tail -F ~/.chia/mainnet/log/debug.log
  else
    while true;do sleep 10;done
  fi

elif [ ${mode} = "farmer" ];then
  sed -i "s/xxx.xxx.xxx.xxx/${farmer_address}/g" /etc/vsftpd.conf
  systemctl start vsftpd
  chia start farmer-only
  trap 'chia stop farmer-only' TERM
  if ${verbose}; then
    tail -F ~/.chia/mainnet/log/debug.log
  else
    while true;do sleep 10;done
  fi

elif [ ${mode} = "harvester" ];then
  sh get_ca.sh
  chia init --create-certs ${certs_dir}
  chia configure --set-farmer-peer ${farmer_address}:${farmer_port}
  trap 'chia stop harvester' TERM
  chia start harvester
  if ${verbose}; then
    tail -F ~/.chia/mainnet/log/debug.log
  else
    while true;do sleep 10;done
  fi

elif [ ${mode} = "plotter" ];then
  trap 'rm -rf ${work_dir}' TERM
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  rm -rf ${work_dir}/*
  chia plots create -f ${farmer_key} -p ${pool_key} -t ${work_dir} -d ${plots_dir} -k 32 -n ${loop} -b 4500 -r 4
  rm -rf ${work_dir}
  #while true;do sleep 10;done

else
  echo "No Job"
fi
