#!/bin/bash

set -x

parallel-scp --user ec2-user -O "StrictHostKeyChecking no" --hosts=hosts.client ./s3-benchmark /home/ec2-user/s3-benchmark

while read -r line; do 
  parallel-ssh --user ec2-user -O "StrictHostKeyChecking no" --hosts=hosts.minio --timeout=0 -i "sudo bash -c \"echo \\\"${line}\\\" >> /etc/hosts\""
  echo $line
done <<< $(cat /etc/hosts | grep client)

exit 3

while read -r line; do 
  parallel-ssh --user ec2-user -O "StrictHostKeyChecking no" --hosts=hosts.clients --timeout=0 -i "sudo bash -c \"echo \\\"${line}\\\" >> /etc/hosts\""
  echo $line
done <<< $(cat /etc/hosts | grep minio)

while read -r line; do
  ip=$(echo ${line} | awk '{print $1}')
  host=$(echo ${line} | awk '{print $2}' | cut -d- -f2)
  ssh -o StrictHostKeyChecking=no ec2-user@client-${host} "sudo bash -c \"echo \\\"${ip} minio\\\" >> /etc/hosts\"" &
done <<< $(cat /etc/hosts | grep minio)

