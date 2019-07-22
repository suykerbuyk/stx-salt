#!/bin/bash

set -x

parallel-scp --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio ./sysctls.conf  /home/ec2-user/sysctl.conf
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" -i --hosts=hosts.minio "sudo mv sysctl.conf /etc/sysctl.conf"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" -i --hosts=hosts.minio "sudo sysctl -p"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" -i --hosts=hosts.minio "sudo yum -y update && sudo yum -y install moreutils expect-dev iperf3 sysstat vnstat"

parallel-ssh --hosts=hosts.minio -i --user ec2-user -O "StrictHostKeyChecking=no" "sudo iostat -xcmt 5 2>&1 > iostat.out"
parallel-scp --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio /home/ec2-user/vnstat.sh.host ~/vnstat.sh
parallel-ssh --hosts=hosts.minio -i --user ec2-user -O "StrictHostKeyChecking=no" "/home/ubuntu/vnstat.sh > sudo /dev/tty1 2>&1"

while read -r line; do 
  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio --timeout=0 -i "sudo bash -c \"echo \\\"${line}\\\" >> /etc/hosts\""
  echo $line
done <<< $(cat /etc/hosts | grep minio)

#for i in {1..16}; do
#  ssh ubuntu@minio-$i "setsid iperf3 -s 2>&1 > iperf3_server.out &" &
#  sleep 2;
#  for j in {1..16}; do
#    if [ $i -ne $j ]; then
#      ssh ubuntu@minio-$j "iperf3 -c minio-$i -P 10 2>&1 > iperf3_minio-$i-$j.out"
#    fi
#  done
#done

parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdb" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdc" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdd" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvde" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdf" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdg" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdh" &
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkfs.xfs /dev/xvdi" &

wait

for i in {1..8}; do
  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mkdir -p /mnt/drive${i}"
done

parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdb /mnt/drive1"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdc /mnt/drive2"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdd /mnt/drive3"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvde /mnt/drive4"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdf /mnt/drive5"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdg /mnt/drive6"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdh /mnt/drive7"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio "sudo mount /dev/xvdi /mnt/drive8"

parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "sudo chown -R ec2-user:ec2-user /mnt"

#for i in {0..7}; do 
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd if=/dev/zero of=/mnt/drive$i/test bs=1M count=1024 oflag=direct 2> dd-w-drive$i-1M-1024.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd if=/dev/zero of=/mnt/drive$i/test bs=4M count=256 oflag=direct 2> dd-w-drive$i-4M-256.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd if=/dev/zero of=/mnt/drive$i/test bs=8M count=128 oflag=direct 2> dd-w-drive$i-8M-128.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd if=/dev/zero of=/mnt/drive$i/test bs=16M count=64 oflag=direct 2> dd-w-drive$i-16M-64.out &"
#  
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd of=/dev/null if=/mnt/drive$i/test bs=1M count=1024 iflag=direct 2> dd-r-drive$i-1M-1024.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd of=/dev/null if=/mnt/drive$i/test bs=4M count=256 iflag=direct 2> dd-r-drive$i-4M-256.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd of=/dev/null if=/mnt/drive$i/test bs=8M count=128 iflag=direct 2> dd-r-drive$i-8M-128.out &"
#  parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "setsid dd of=/dev/null if=/mnt/drive$i/test bs=16M count=64 iflag=direct 2> dd-r-drive$i-16M-64.out &"

#  rm -rf /mnt/drive{$i}/test
#done

parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "sudo lscpu 2>&1 > lscpu.out"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "sudo lsmem 2>&1 > lsmem.out"
parallel-ssh --user ec2-user -O "StrictHostKeyChecking=no" --hosts=hosts.minio -i "sudo fdisk -l 2>&1 > fdisk.out"

parallel-scp --hosts=hosts.minio --user ec2-user -O "StrictHostKeyChecking=no" ./minio /home/ec2-user/minio
parallel-ssh --hosts=hosts.minio -i --user ec2-user -O "StrictHostKeyChecking=no" "MINIO_ACCESS_KEY=minio MINIO_SECRET_KEY=minio123 setsid ./minio server http://minio-{1...12}:9000/mnt/drive{1...8} 2>&1 > minio.log"
parallel-ssh --hosts=hosts.minio -i --user ec2-user -O "StrictHostKeyChecking=no" 'setsid top -b -p `pidof minio` 2>&1 >> top.out'

