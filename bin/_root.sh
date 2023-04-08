#!/bin/sh

set -e

if [ -z "$_JAIL_INSIDE"  ];
then
	echo "Please run via 'jail.sh'"
	exit 1
fi

echo "Entered jail to isolate resources!"

# Create temporary directory for mount points
rootmount=$_JAIL_MOUNT_DIR
if [ ! -d $rootmount ];
then
	mkdir $rootmount
fi

devpts="$rootmount/pts"
mkdir -p $devpts
newtmp="$rootmount/tmp"
mkdir -p $newtmp

# Make the directories easy to delete afterwards
chown -R $_JAIL_UID:$_JAIL_GID $rootmount && \
chmod -R 1755 $rootmount

# Mount new devpts
echo "Mount new devpts..."
mount \
	-o newinstance,mode=620,gid=5,nosuid,rw,noexec,relatime,ptmxmode=0666 \
	-t devpts \
	devpts $devpts
mount --bind $devpts /dev/pts

# Mount to ptmx
echo "Bind new devptx to ptmx system..."
mount \
	--bind \
	-o nosuid,noexec \
	/dev/pts/ptmx /dev/ptmx

# Mount new tmpfs
echo "Mount new tmpfs..."
mount \
	-t tmpfs \
	none $newtmp
mount --bind $newtmp /tmp

# Finally run the desired command
echo "Executing '$@'..."
exec "$@"
