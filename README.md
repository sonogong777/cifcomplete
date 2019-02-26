# cifcomplete
#
#

Workaround to support CIFS in VOD workflow.
1. Post cif yum repo on v2pc repo
2. Install required packages on the packagers
   a. nfs-utils
   b. fuse
   c. cif-utils
3. Deploy services.

REQUIREMENTS:
------------
+ Copy file cifcomplete.tgz on the site.


PREWORK:
-----
 Create workflow with the mediasource NFS server as 127.0.0.1 NFS v.3 with /nfsshare.

WORKFLOW:
--------
1. Execute first.sh with the site information:
   Usage: ./first.sh <cif server> <user> <password> <cif directory> <VOD MCE name>
Example: ./first.sh 10.127.208.157 root cisco cif CE-VOD

2. scp cifrepo.tgz to v2pc repo;execute /home/v2pc/cifrepo.sh
3. scp cifsetup.v2pc.tgz to v2pc master /root directory.
4. tar xzvf cifsetup.v2pc.tgz -C /root/
3. execute /root/cifsetup.sh.
4. Enable workflow confirm the /media directories being mount.
