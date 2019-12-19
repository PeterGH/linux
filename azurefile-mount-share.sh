#!/bin/bash

USAGE="USAGE:
$(basename $0) //<account_name>.file.core.windows.net/<share_name> <storage_account_key>
$(basename $0) <account_name> <share_name> <storage_account_key>"

if [ $# -lt 2 ]
then
	echo -e "$USAGE"
	exit 1
fi

if [[ "${1:0:2}" == "//" ]]
then
	echo "Share path $1"
	sharePath=$1
	accountKey=$2
	endpoint=$(echo $sharePath | cut -d/ -f 3)
	# endpoint=${sharePath:2}
	accountName=$(echo $endpoint | cut -d. -f 1)
	shareName=$(echo $sharePath | cut -d/ -f 4)
else
	echo "Account name $1"
	if [ $# -lt 3 ]
	then
		echo -e "$USAGE"
		exit 1
	fi
	accountName=$1
	shareName=$2
	accountKey=$3
	endpoint=$accountName.file.core.windows.net
	sharePath=//$endpoint/$shareName
fi

if [[ "$sharePath" != "//"* ]]
then
	echo "Invalid share path $sharePath"
	exit 1
fi

echo $sharePath
echo $endpoint
echo $accountName
echo $accountKey
echo $shareName

mntPath=/mnt/$accountName/$shareName

if [ ! -d "$mntPath" ]
then
	sudo mkdir -p $mntPath
	status=$?
	if [ $status != 0 ]
	then
		echo "Failed to mkdir $mntPath, error code $status"
		exit $status
	fi
fi

echo "mount $sharePath to $mntPath"
sudo mount -t cifs $sharePath $mntPath -o vers=3.0,username=$accountName,password=$accountKey,serverino
status=$?
if [ $status != 0 ]
then
	echo "Failed to mount $sharePath, error code $status"
	exit $status
fi
