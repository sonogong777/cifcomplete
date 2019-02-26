#!/bin/bash
#
#  Ken Rhee
#  :-S
#  krhee@synamedia.com
#
#
# CIF server IP is derrived from the mount command so if it is not avilable
# Please update the CIF with the actual IP.
#
VERSION=0.1
NFSMOUNT=/nfsshare
SLEEP=10
#need to be root
[ "$(whoami)" != "root" ] && { echo "Need to be root"; exit 1; }
while [ $(mount|grep cif > /dev/null;echo $?) -eq "1" ];do
    echo "Waiting on CIF, sleep $SLEEP"
    sleep $SLEEP
    #try to mount cif from cif.conf
    mount -a
done
echo "cif mounted"
#Extract cif mount point
  CIF=$(mount|grep cif|awk '{print $3}')
while [ $(mount |grep convmvfs > /dev/null;echo $?) -eq "1" ];do
#Mount fuse
  convmvfs $NFSMOUNT -o srcdir=$CIF -o icharset=iso-8859-1 -o ocharset=iso-8859-1
  sleep $SLEEP
#Restart nfs-server
  systemctl restart nfs-server
done
echo "fuse and nfs mount confirmed"

