#!/bin/sh
set -e
# Figure out where we are being run
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
PRG_CHAR="·"
#
DISK_TYPE='ST10000'
DiskPrep() {
	printf "Clear Start of Disk LBAs: \n "
	for disk in $( lsblk -p -S | grep $DISK_TYPE | sort | awk '{print $1}')
	do
		(dd if=/dev/zero of=$disk bs=1M count=256 2>/dev/null && printf "$PRG_CHAR" ) &
	done
	wait 
	printf "\nClear End of Disk LBAs: \n "
	for disk in $( lsblk -p -S | grep $DISK_TYPE | sort | awk '{print $1}')
	do
		(dd if=/dev/zero of=$disk bs=512 count=1024 seek=$((`blockdev --getsz $disk` - 1024)) 2>/dev/null && printf "$PRG_CHAR" ) &
	done
	wait 
	printf "\ndone\n\n"

}
DiskPrep
