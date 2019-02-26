#!/bin/bash
#
#
#
CIFSERVER="10.127.208.157"
salt_cli(){
CLI="$1"
salt '*CE-VOD-*' cmd.run "$CLI"
}

echo "Backing up yum.repo"
salt_cli "mv /etc/yum.repos.d/Cent* /etc/yum.repos.d/epel* /root/;cp /etc/yum.repos.d/v2pc.repo /etc/yum.repos.d/cif.repo;ls -al /etc/yum.repos.d/"
echo "Create cif.repo"
salt_cli "sed -i 's/cisco.*\$/cisco\/cif/g' /etc/yum.repos.d/cif.repo;sed -i 's/v2pc/cif/g' /etc/yum.repos.d/cif.repo;grep -e cisco -e cif /etc/yum.repos.d/cif.repo"
echo "Enable cif.repo"
salt_cli "yum-config-manager --enable cif"
echo "Yum install samba samba-client cifs-utils nfs-utils samba-common libnfsidmap fuse fuse-libs fuse-convmvfs"
salt_cli "yum install samba samba-client cifs-utils nfs-utils samba-common libnfsidmap fuse fuse-libs fuse-convmvfs --skip-broken -y"
echo "Create mount directories: /mnt/cif /nfsshare"
salt_cli "mkdir -p /mnt/cif;mkdir -p /nfsshare;chmod -R 777 /nfsshare;chmod -R 777 /mnt/cif"
echo "Mounting cif mount -t cifs -o user=root,password=cisco //$CIFSERVER/cif/samba /mnt/cif"

salt_cli "echo '//10.127.208.157/cif /mnt/cif cifs username=root,password=cisco,soft,rw 0 0' >> /etc/fstab;umount /mnt/cif;mount -a"
salt_cli "echo hello > /mnt/cif/\$(hostname)"

echo "Setup nfsshare"
salt_cli "echo '/nfsshare *(no_subtree_check,fsid=0,rw,sync,no_root_squash,no_all_squash)' >> /etc/exports"
salt_cli "systemctl enable rpcbind;systemctl enable nfs-server;systemctl enable nfs-lock;systemctl enable nfs-idmap"
salt_cli "systemctl start rpcbind;systemctl start nfs-lock;systemctl start nfs-idmap"

echo "Setup fuse and start nfsshare"
salt-cp "*CE-VOD-*" /root/cifsource.sh /root/cifsource.sh
salt-cp "*CE-VOD-*" /root/root.cron /root/root.cron

salt_cli "chmod 777 /root/cifsource.sh;/root/cifsource.sh"
salt_cli "crontab /root/root.cron;crontab -l;df -h"

echo "Please enable workflow"
