#!/bin/sh
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
set -e

if [ -f json.out ]; then
   rm -f json.out
fi
extra="test=True"
extra=""
salt -c '/opt/stx/stx-salt/' -N minio_client grains.set 'stx:s3-bench:duration' "60" >>test.log
for obj_size in 1M 2M 4M 8M 16M 32M 48M 64M 96M 112M 128M 144M 160M 176M 192M 208M 224M 240M 256M 
do
    for threads in 1 2 4 8 12 16 20 24 28 32 36 40 44
    do
	echo "Block Size: $obj_size   Threads: $threads"
        salt -c '/opt/stx/stx-salt/' -N minio_client grains.set 'stx:s3-bench:obj_size' "$obj_size" >>test.log
        salt -c '/opt/stx/stx-salt/' -N minio_client grains.set 'stx:s3-bench:threads' "$threads" >>test.log
        salt -c '/opt/stx/stx-salt/' -N minio_client state.sls test.s3bench.test  --out=json $extra | tee -a json.out
    done
done
