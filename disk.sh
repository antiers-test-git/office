#!/bin/bash
DISKUSE=$(df -h /data|tail -1| awk '{ print $5 }'|tr -d "%")
if (( $DISKUSE > 70 )); then
VOLUMEID=`aws ec2 describe-volumes --region $REGION --filter Name=tag:Name,Values=$DISKNAME | grep VolumeId |tail -1|sed 's/[",]//g'` 
VOLUMEID="${VOLUMEID#*:}"
TOTALVOLUMESIZE=$(df -h /data|tail -1| awk '{ print $2 }'|sed 's/[G]//g')
ADDMOREVOLUME=$(( TOTALVOLUMESIZE + TOTALVOLUMESIZE * 30 / 100 ))
aws ec2 modify-volume --size $ADDMOREVOLUME --volume-id $VOLUMEID --region $REGION
sleep 30
sudo xfs_growfs -d /data
fi
