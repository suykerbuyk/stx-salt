#!/bin/sh
set -e
# Figure out where we are being run
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
MINIO_SERVER_SCRIPT="$SCRIPTPATH/LaunchMinioServer.sh"
#
DISK_TYPE='ST10000'
MNT_TOP_DIR='/minio_test'
MNT_DIR_PREFIX='disk'
#PRG_CHAR="•"
PRG_CHAR="·"
PAD_STR='000'


PAD_LEN=$(( $(echo $PAD_STR | wc -c) - 1 ))

DirCleanUp() {
	# Nothing to do if we don't have the topdir.
	if [ -d "$MNT_TOP_DIR" ] 
	then
		printf "Cleaning up mount point(s)\n "
		for mnt in $(mount -l  | grep "$MNT_TOP_DIR" | awk '{print $3}')
	       	do
			printf "$PRG_CHAR"
			umount "$mnt"
			rmdir "$mnt"
		done
		rm -rf  "$MNT_TOP_DIR"
		printf "\ndone.\n\n"
	fi
}
DirSetUp() {
	if [ ! -d "$MNT_TOP_DIR" ]
	then
		printf "Creating top level disk mount directory\n"
		mkdir "$MNT_TOP_DIR"
		printf "done.\n\n"
	fi

}
DiskPrep() {
	printf "Disk Prep: \n "
	for disk in $( lsblk -p -S | grep $DISK_TYPE | sort | awk '{print $1}')
	do
		(dd if=/dev/zero of=$disk bs=1M count=256 2>/dev/null && printf "$PRG_CHAR" ) &
	done
	wait 
	printf "\ndone\n\n"

	printf "Formatting disk: \n "
	for disk in $( lsblk -p -S | grep $DISK_TYPE | sort | awk '{print $1}')
	do
		(mkfs.xfs -q $disk && printf "$PRG_CHAR") &
	done
	wait || exit 1
	printf "\ndone\n\n"
}
MountFileSystems() {
	printf "Mounting File Systems...\n "
	[ -d "$MNT_TOP_DIR" ] || DirSetUp
	DSK_CNT=$(lsblk -p -S| grep $DISK_TYPE |  awk '{print $1}'| wc -l)
	for disk in $(lsblk -p -S| grep $DISK_TYPE |  awk '{print $1}')
	do
		for x in $(seq 1 $DSK_CNT)
		do
			NUM=$(printf "$PAD_STR$x" | tail -c $PAD_LEN)
			MNT_PATH="$MNT_TOP_DIR/disk$NUM"
			if [ ! -d "$MNT_PATH" ] 
			then
				mkdir "$MNT_PATH" 
				(mount "$disk" "$MNT_PATH" && printf "$PRG_CHAR") &
				break
			fi
		done
	done
	wait || exit 1
	printf "\ndone\n\n"
}
CreateMinioLauncher() {
	printf "Creating minio server launch script\n"
	disk_1="$(ls $MNT_TOP_DIR/ | sort | head -1 | awk -F "/" '{print $NF}')"
	disk_1="$(printf $disk_1 | tail -c $PAD_LEN)"
	disk_n="$(ls $MNT_TOP_DIR/ | sort | tail -1 | awk -F "/" '{print $NF}')"
	disk_n="$(printf $disk_n | tail -c $PAD_LEN)"
	cat <<- SCRIPT >$MINIO_SERVER_SCRIPT
		export MINIO_ACCESS_KEY=\${MINIO_ACCESS_KEY:=admin}
		export MINIO_SECRET_KEY=\${MINIO_SECRET_KEY:=password}
		minio server $MNT_TOP_DIR/$MNT_DIR_PREFIX{$disk_1...$disk_n}
	SCRIPT
	chmod a+x $MINIO_SERVER_SCRIPT
	printf "done\n To Start MinIO server: $(realpath $MINIO_SERVER_SCRIPT)\n\n"
}
DirCleanUp
DirSetUp
DiskPrep
MountFileSystems
CreateMinioLauncher
