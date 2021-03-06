#!/bin/bash
#
#
#
#

usage() {
    echo "Usage: $0 <cif server> <user> <password> <cif directory> <VOD MCE name>"
    echo "Example: $0 10.127.208.157 root cisco cif CE-VOD"
}

if [ $# -le 3 ];then 
   usage
   exit 1
fi

CIFSERVER="$1"
USER="$2"
PASS="$3"
DIR="$4"
NAME="CE-VOD"
if [ $# == 5 ];then
    NAME="$5"
fi
mkdir cifsetup/
tar xzvf cifsetup.v2pc.tgz -C cifsetup/
echo "Will update the script with the site specific information"
echo "updating cifsetup.sh but feel free to manually update as needed"
cp cifsetup/cifsetup.sh cifsetup/cifsetup.sh.back
sed -i "s/10.127.208.157\/cif/10.127.208.157\/$DIR/g" cifsetup/cifsetup.sh
sed -i "s/10.127.208.157/$CIFSERVER/g" cifsetup/cifsetup.sh
sed -i "s/username\=root/username\=$USER/g" cifsetup/cifsetup.sh
sed -i "s/password\=cisco/password\=$PASS/g" cifsetup/cifsetup.sh
sed -i "s/CE-VOD-/$NAME/g" cifsetup/cifsetup.sh

echo "creating cifsetup.v2pc.tgz"
cd cifsetup/
tar xzvf ../cifsetup.v2pc.tgz *
