#!/bin/sh
echo Access to ${farmer_address}:${ftp_port}

ftp -p -n <<EOF
  open ${farmer_address} ${ftp_port}
  user anonymous
  binary
  lcd ${certs_dir}
  get chia_ca.crt
  get chia_ca.key
  get private_ca.crt
  get private_ca.key
  bye
EOF
