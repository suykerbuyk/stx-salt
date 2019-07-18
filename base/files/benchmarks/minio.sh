#!/bin/bash

set -x

if [[ $(whoami) != "root" ]]; then
	echo "please run as sudo"
	exit 1
fi

#sudo apt-get update && sudo apt-get install -y vnstat sysstat iperf3 moreutils expect-dev

#download
#wget https://dl.min.io/server/minio/release/linux-amd64/minio
#chmod +x minio
#sudo mv minio /usr/bin/

#environment monitoring
#setsid iostat -xcmt 5 2>&1 > iostat.out &
#setsid ./vnstat.sh > sudo /dev/tty1 2>&1 
#drives=$(sudo fdisk -l | grep 12.8.TiB | awk '{print $2}' | cut -d: -f1)
#set -x;i=0;for d in $drives; do i=$((i+1));mntpath='/mnt/drive'$i; mkdir -p $mntpath; sudo mount $d $mntpath ; done

#hardware capability
#setsid iperf3 -s 2>&1 > iperf3_server.out &
iperf3 -c 10.10.0.1 -P 100 > iperf3-10.10.0.2-to-10.10.0.1.out

#./iozone -t 48 -I -r 1M -s 256M -F /mnt/drive{1..48}/tmp 2>&1 > iozone-1M-256M-48t.out
#./iozone -t 96 -I -r 1M -s 128M -F /mnt/drive{1..48}/tmp{1..2} 2>&1 > iozone-1M-128M-96t.out
#./iozone -t 144 -I -r 1M -s 96M -F /mnt/drive{1..48}/tmp{1..3} 2>&1 > iozone-1M-96M-144t.out
#./iozone -t 192 -I -r 1M -s 64M -F /mnt/drive{1..48}/tmp{1..4} 2>&1 > iozone-1M-64M-192t.out
#./iozone -t 240 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..5} 2>&1 > iozone-1M-32M-240t.out
#./iozone -t 288 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..6} 2>&1 > iozone-1M-32M-288t.out
#./iozone -t 336 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..7} 2>&1 > iozone-1M-32M-336t.out
#./iozone -t 384 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..8} 2>&1 > iozone-1M-32M-394t.out
#./iozone -t 432 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..9} 2>&1 > iozone-1M-32M-432t.out
#./iozone -t 480 -I -r 1M -s 32M -F /mnt/drive{1..48}/tmp{1..10} 2>&1 > iozone-1M-32M-480t.out

dd if=/dev/zero of=/mnt/drive1/test bs=1M count=1024 oflag=direct 3>&1 2>&1 > dd-w-drive1-1M-1024.out
dd if=/dev/zero of=/mnt/drive1/test bs=4M count=256 oflag=direct 3>&1 2>&1 > dd-w-drive1-4M-256.out
dd if=/dev/zero of=/mnt/drive1/test bs=8M count=128 oflag=direct 3>&1 2>&1 > dd-w-drive1-8M-128.out
dd if=/dev/zero of=/mnt/drive1/test bs=16M count=64 oflag=direct 3>&1 2>&1 > dd-w-drive1-16M-64.out

dd of=/dev/null if=/mnt/drive1/test bs=1M count=1024 iflag=direct 3>&1 2>&1 > dd-r-drive1-1M-1024.out
dd of=/dev/null if=/mnt/drive1/test bs=4M count=256 iflag=direct 3>&1 2>&1 > dd-r-drive1-4M-256.out
dd of=/dev/null if=/mnt/drive1/test bs=8M count=128 iflag=direct 3>&1 2>&1 > dd-r-drive1-8M-128.out
dd of=/dev/null if=/mnt/drive1/test bs=16M count=64 iflag=direct 3>&1 2>&1 > dd-r-drive1-16M-64.out

#cleanup
rm -r /mnt/drive1/test

#hw info
#lscpu 2>&1 > lscpu.out
#lsmem 2>&1 > lsmem.out
#fdisk -l 2>&1 > fdisk.out

#setup
export MINIO_ACCESS_KEY=minio
export MINIO_SECRET_KEY=minio123
setsid minio server  http://10.10.0.1:9000/mnt/drive{1...48} http://10.10.0.2:9000/mnt/drive{1...48} 2>&1 > minio.log &
setsid top -b -p $(pidof minio) 2>&1 > top.out &
