#!/bin/bash
#
# bash script to backup files using rsync
# from a $SOURCE_DIR to a $TARGET_DIR
#

DEFAULT_CONFIG=$XDG_CONFIG_HOME/cronBackup.conf

CONFIG=$1

logger -s "Initialising backup..."
if [ "$CONFIG" == "" ]; then
    CONFIG=$DEFAULT_CONFIG
fi

logger -s "...reading configuration file: $CONFIG"
source $CONFIG

logger -s "...checking target: $TARGET_DIR"
if grep -qs "$TARGET_MOUNT" /proc/mounts; then
    logger "...device mounted"
else
    logger -s "...attempting to mount device"
    mount $TARGET_DEVICE $TARGET_MOUNT 
    if [ ! $? == 0 ]; then
        logger -s "...could not mount device!"
        exit
    fi
fi


if [ -d "$TARGET_DIR" ]; then
    logger "...directory exists"
else
    logger -s "...attempting to create directory"
    mkdir -p $TARGET_DIR
    if [ ! $? == 0 ]; then
        logger -s "...could not create directory!"
	exit
    fi
fi

logger -s "Starting sync..."
rsync -r $SOURCE_DIR/ $TARGET_DIR
logger -s "...complete"
