#!/bin/bash
echo HOSTNAME `hostname`
sleep_time=10
chia="chia"

. activate

if [ ${mode} = "master" ];then
  ${chia} init
  ${chia} init --create-certs ${ca_dir}
  cp /root/${conf_dir}/mainnet/config/_config.yaml /root/${conf_dir}/mainnet/config/config.yaml
  ${chia} keys add -f ${key_file}
  ${chia} configure --log-level INFO
  sed -i 's/localhost/127.0.0.1/g' /root/${conf_dir}/mainnet/config/config.yaml
  sed -i 's/log_stdout: false/log_stdout: true/g' /root/${conf_dir}/mainnet/config/config.yaml
  ${chia} start node
  ${chia} start farmer-only
  ${chia} start wallet-only
  #trap 'chia stop farmer' TERM INT STOP ERR
  while true;do sleep ${sleep_time};done

elif [ ${mode} = "harvester" ];then
  sleep 10
  ${chia} init
  ${chia} init --create-certs ${ca_dir}
  cp /root/${conf_dir}/mainnet/config/_config.yaml /root/${conf_dir}/mainnet/config/config.yaml
  ${chia} keys add -f ${key_file}
  ${chia} configure --set-farmer-peer ${farmer_address}:${farmer_port}
  ${chia} configure --log-level INFO
  ${chia} plots add -d ${plots_dir}
  sed -i 's/localhost/127.0.0.1/g' /root/${conf_dir}/mainnet/config/config.yaml
  sed -i 's/log_stdout: false/log_stdout: true/g' /root/${conf_dir}/mainnet/config/config.yaml
  ${chia} start harvester
  #trap 'chia stop harvester' TERM INT STOP ERR
  while true;do sleep ${sleep_time};done

elif [ ${mode} = "plotter" ];then
  ${chia} init
  ${chia} configure --log-level INFO
  trap 'rm -rf ${work_dir}' TERM INT STOP ERR
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  rm -rf ${work_dir}/*
  ${chia} plots create -f ${farmer_key} -p ${pool_key} -t ${work_dir} -d ${plots_dir} -n ${loop} -r ${thread} -k 32 -b 4500
  rm -rf ${work_dir}

elif [ ${mode} = "plotter-fast" ];then
  trap 'rm -rf ${work_dir}' TERM INT STOP ERR
  work_dir=${tmp_dir}/`hostname`
  mkdir ${work_dir}
  #for I in `seq ${loop}`
  #  do rm ${plots_dir}/`ls /plots/|sort|head -n1`
  #done
  ${chia} plotters madmax -f ${farmer_key} -c ${singleton_address} -t ${work_dir}/ -d ${plots_dir}/ -n ${loop} -r ${thread}
  rm -rf ${work_dir}

else
  echo "No Job"
fi
